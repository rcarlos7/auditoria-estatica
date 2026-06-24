# Checklist de Prueba Estática — IEEE 1028

**Proyecto:** DemoAuditApp  
**Estándar:** IEEE 1028 — Static Analysis Techniques  
**Fecha:** 2025  
**Auditores:** [Nombres del equipo]  
**Versión:** 1.0

---

## 1. Estándares de Código C#

| # | Criterio | Cumple | No Cumple | Observación |
|---|----------|--------|-----------|-------------|
| 1.1 | El código sigue convenciones de nomenclatura de C# (PascalCase para clases, camelCase para variables) | ☐ | ☐ | |
| 1.2 | Los archivos tienen una sola responsabilidad por clase | ☐ | ☐ | |
| 1.3 | No se usan números mágicos sin constantes nombradas | ☐ | ☐ | |
| 1.4 | Las clases y métodos tienen tamaño razonable (<50 líneas por método) | ☐ | ☐ | |
| 1.5 | No existe código duplicado o dead code | ☐ | ☐ | |

---

## 2. Seguridad Básica

| # | Criterio | Cumple | No Cumple | Observación |
|---|----------|--------|-----------|-------------|
| 2.1 | Todas las entradas del usuario son validadas antes de procesarse | ☐ | ☐ | |
| 2.2 | No se usan métodos inseguros (`int.Parse` sin try-catch en lugar de `TryParse`) | ☐ | ☐ | |
| 2.3 | No se exponen datos sensibles en logs o consola | ☐ | ☐ | |
| 2.4 | No hay credenciales hardcodeadas en el código fuente | ☐ | ☐ | |
| 2.5 | Se aplica el principio de mínimo privilegio en la lógica de acceso | ☐ | ☐ | |

---

## 3. Mantenibilidad

| # | Criterio | Cumple | No Cumple | Observación |
|---|----------|--------|-----------|-------------|
| 3.1 | El código tiene estructura modular (separación de responsabilidades) | ☐ | ☐ | |
| 3.2 | Los métodos tienen nombres descriptivos que reflejan su función | ☐ | ☐ | |
| 3.3 | No existen dependencias circulares entre módulos | ☐ | ☐ | |
| 3.4 | El índice de complejidad ciclomática es aceptable (<10 por método) | ☐ | ☐ | |
| 3.5 | El código es legible sin necesidad de comentarios para entenderse | ☐ | ☐ | |

---

## 4. Documentación

| # | Criterio | Cumple | No Cumple | Observación |
|---|----------|--------|-----------|-------------|
| 4.1 | Existe documentación XML (`///`) en clases y métodos públicos | ☐ | ☐ | |
| 4.2 | El repositorio tiene un README con descripción del proyecto | ☐ | ☐ | |
| 4.3 | Los métodos complejos tienen comentarios explicativos | ☐ | ☐ | |
| 4.4 | Existe un archivo de changelog o historial de versiones | ☐ | ☐ | |
| 4.5 | Las excepciones capturadas están documentadas con su razón | ☐ | ☐ | |

---

## 5. Buenas Prácticas C#

| # | Criterio | Cumple | No Cumple | Observación |
|---|----------|--------|-----------|-------------|
| 5.1 | Se usa `TryParse` en lugar de `Parse` para entrada del usuario | ☐ | ☐ | |
| 5.2 | Se implementa manejo de excepciones con `try-catch-finally` | ☐ | ☐ | |
| 5.3 | Se usan tipos nullables correctamente (`string?`, `int?`) | ☐ | ☐ | |
| 5.4 | No se usa `Console.ReadLine()` sin validar el resultado nulo | ☐ | ☐ | |
| 5.5 | Se implementa logging estructurado (ILogger, Serilog, etc.) | ☐ | ☐ | |
| 5.6 | Existen pruebas unitarias para la lógica de negocio | ☐ | ☐ | |

---

## 6. Cumplimiento DevOps

| # | Criterio | Cumple | No Cumple | Observación |
|---|----------|--------|-----------|-------------|
| 6.1 | Existe un pipeline CI/CD configurado (GitHub Actions / Azure DevOps) | ☐ | ☐ | |
| 6.2 | El pipeline ejecuta análisis estático automático en cada push | ☐ | ☐ | |
| 6.3 | El pipeline bloquea merges si hay errores de análisis estático | ☐ | ☐ | |
| 6.4 | Existe archivo `.gitignore` adecuado para proyectos .NET | ☐ | ☐ | |
| 6.5 | El proyecto usa versiones fijas de dependencias (no `*` en NuGet) | ☐ | ☐ | |
| 6.6 | Se generan reportes de auditoría automáticamente en cada ejecución | ☐ | ☐ | |

---

## Resumen de Evaluación

| Categoría | Total Criterios | Cumplen | No Cumplen | % Cumplimiento |
|-----------|----------------|---------|------------|----------------|
| Estándares de Código | 5 | | | |
| Seguridad Básica | 5 | | | |
| Mantenibilidad | 5 | | | |
| Documentación | 5 | | | |
| Buenas Prácticas C# | 6 | | | |
| Cumplimiento DevOps | 6 | | | |
| **TOTAL** | **32** | | | |

---

## Resultado de la Auditoría

- [ ] **APROBADO** — Cumplimiento ≥ 80%
- [ ] **OBSERVADO** — Cumplimiento entre 60% y 79%
- [ ] **RECHAZADO** — Cumplimiento < 60%

**Firma del Auditor:** _______________  
**Fecha:** _______________