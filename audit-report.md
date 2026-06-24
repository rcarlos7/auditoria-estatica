# Reporte de Auditoría Estática — IEEE 1028

**Proyecto:** DemoAuditApp  
**Auditor(es):** [Nombres del equipo]  
**Fecha:** 2025  
**Versión del código:** 1.0  
**Estándar aplicado:** IEEE 1028 — Static Analysis Techniques

---

## 1. Resumen Ejecutivo

Se realizó una auditoría de técnicas estáticas sobre el proyecto DemoAuditApp, una aplicación de consola en C# que implementa control de acceso por edad. El análisis se ejecutó mediante el script automatizado `audit-script.ps1` integrado al pipeline CI/CD de GitHub Actions.

| Indicador | Resultado |
|-----------|-----------|
| Archivos auditados | 1 (`Program.cs`) |
| Errores críticos (ERROR) | 2 |
| Advertencias (WARNING) | 4 |
| Criterios evaluados | 32 |
| Criterios cumplidos | 8 |
| **% Cumplimiento** | **25%** |
| **Resultado** | ❌ RECHAZADO |

---

## 2. Hallazgos Detallados

### 🔴 ERRORES CRÍTICOS

#### [S-01] Uso de `int.Parse()` sin validación
- **Ubicación:** `Program.cs`, línea 10
- **Código afectado:**
```csharp
  int edad = int.Parse(Console.ReadLine());
```
- **Riesgo:** Si el usuario ingresa un valor no numérico (letras, vacío, nulo), el programa lanzará una excepción no controlada `FormatException` o `OverflowException`, causando una caída abrupta de la aplicación.
- **Recomendación:**
```csharp
  if (!int.TryParse(Console.ReadLine(), out int edad))
  {
      Console.WriteLine("Entrada inválida. Ingrese un número.");
      return;
  }
```

#### [E-01] Ausencia total de manejo de excepciones
- **Ubicación:** `Program.cs` — método `Main`
- **Riesgo:** La aplicación no tiene ningún bloque `try-catch`. Cualquier error de ejecución (entrada inválida, null reference) termina el proceso sin mensaje controlado. En producción esto genera una experiencia de usuario pésima y dificulta el diagnóstico de fallas.
- **Recomendación:** Envolver la lógica principal en un bloque `try-catch-finally` con logging del error.

---

### 🟡 ADVERTENCIAS

#### [S-02] `Console.ReadLine()` sin verificación de null
- **Ubicación:** `Program.cs`, línea 10
- **Riesgo:** `Console.ReadLine()` puede devolver `null` si el stream de entrada está redirigido (pipelines, CI/CD). Esto provoca un `NullReferenceException` al pasarlo a `int.Parse()`.
- **Recomendación:** Usar `Console.ReadLine() ?? string.Empty` antes de procesar.

#### [D-01] Sin documentación XML
- **Ubicación:** `Program.cs` — clase `Program` y método `Main`
- **Riesgo:** El código no tiene ningún comentario `/// <summary>`. Esto impide la generación automática de documentación con Sandcastle o DocFX y dificulta el onboarding de nuevos desarrolladores.
- **Recomendación:** Agregar documentación XML mínima en la clase y el método principal.

#### [D-02] Sin comentarios explicativos
- **Ubicación:** `Program.cs` — todo el archivo
- **Riesgo:** La lógica de negocio (criterio de edad > 18) no tiene ningún comentario que explique la regla de negocio. Si el criterio cambia, no hay referencia a documentación de requerimientos.
- **Recomendación:** Agregar al menos un comentario indicando el origen del criterio de edad.

#### [C-02] Lógica de negocio en `Main()`
- **Ubicación:** `Program.cs`, método `Main`
- **Riesgo:** El método `Main` mezcla responsabilidades: captura de entrada, validación y lógica de acceso. Esto viola el principio de responsabilidad única (SRP) y hace el código difícil de probar con pruebas unitarias.
- **Recomendación:** Extraer la lógica de verificación a un método separado:
```csharp
  static bool VerificarAcceso(int edad) => edad > 18;
```

---

## 3. Hallazgos Adicionales (Análisis Manual)

Estos hallazgos fueron identificados por revisión manual del código, complementando el análisis automatizado:

| # | Hallazgo | Severidad |
|---|----------|-----------|
| A-01 | Lógica incorrecta: `edad > 18` excluye exactamente los 18 años, cuando la regla debería ser `edad >= 18` | ERROR |
| A-02 | Sin pruebas unitarias en todo el proyecto | WARNING |
| A-03 | Sin archivo `.gitignore` en el repositorio inicial | WARNING |
| A-04 | Sin logging estructurado (ILogger, Serilog) | WARNING |
| A-05 | El proyecto no tiene archivo `.csproj` con analyzers configurados | WARNING |

---

## 4. Matriz de Riesgos

| Hallazgo | Probabilidad | Impacto | Riesgo | Prioridad |
|----------|-------------|---------|--------|-----------|
| S-01: int.Parse sin validación | Alta | Alto | **CRÍTICO** | Inmediata |
| E-01: Sin try-catch | Alta | Alto | **CRÍTICO** | Inmediata |
| A-01: Lógica > vs >= | Media | Alto | **ALTO** | Corto plazo |
| S-02: ReadLine sin null check | Media | Medio | **MEDIO** | Corto plazo |
| A-02: Sin pruebas unitarias | Alta | Medio | **MEDIO** | Medio plazo |
| D-01/D-02: Sin documentación | Baja | Medio | **BAJO** | Largo plazo |
| C-02: Lógica en Main | Alta | Bajo | **BAJO** | Largo plazo |

---

## 5. Recomendaciones Generales

1. **Inmediato:** Reemplazar `int.Parse` por `int.TryParse` con manejo del caso inválido antes de cualquier despliegue.
2. **Corto plazo:** Implementar un bloque `try-catch` global en `Main` con logging básico de errores.
3. **Corto plazo:** Corregir la lógica de negocio de `> 18` a `>= 18` si el criterio es mayoría de edad inclusive.
4. **Medio plazo:** Refactorizar `Main` para separar responsabilidades y habilitar pruebas unitarias.
5. **Largo plazo:** Configurar `.editorconfig` y `.csproj` con `TreatWarningsAsErrors=true` y los analyzers de .NET.

---

## 6. Código Corregido Propuesto

```csharp
using System;
using Microsoft.Extensions.Logging;

namespace DemoAuditApp
{
    /// <summary>
    /// Aplicación de control de acceso por edad.
    /// </summary>
    class Program
    {
        /// <summary>
        /// Punto de entrada principal de la aplicación.
        /// </summary>
        static void Main(string[] args)
        {
            try
            {
                Console.WriteLine("Ingrese su edad:");
                string? input = Console.ReadLine();

                // Validar que la entrada no sea nula ni vacía
                if (!int.TryParse(input, out int edad) || edad < 0)
                {
                    Console.WriteLine("Error: ingrese un número entero válido.");
                    return;
                }

                // Regla de negocio: acceso permitido para mayores de edad (>= 18)
                if (VerificarAcceso(edad))
                    Console.WriteLine("Acceso permitido");
                else
                    Console.WriteLine("Acceso denegado");
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Error inesperado: {ex.Message}");
                Environment.Exit(1);
            }
        }

        /// <summary>
        /// Verifica si una persona tiene acceso según su edad.
        /// </summary>
        /// <param name="edad">Edad ingresada por el usuario.</param>
        /// <returns>True si tiene acceso, false en caso contrario.</returns>
        static bool VerificarAcceso(int edad) => edad >= 18;
    }
}
```

---

## 7. Conclusión

El proyecto DemoAuditApp presenta deficiencias graves en seguridad y manejo de errores que lo hacen no apto para despliegue en producción en su estado actual. Los 2 errores críticos identificados (S-01 y E-01) deben corregirse antes de cualquier merge a la rama principal. El pipeline CI/CD configurado con `audit-script.ps1` bloqueó correctamente el despliegue al detectar estos errores.

**Resultado final:** ❌ RECHAZADO — Requiere correcciones críticas antes del merge.