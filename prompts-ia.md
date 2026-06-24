# Prompts de IA Generativa — Auditoría IEEE 1028

**Herramienta utilizada:** Claude (Anthropic)  
**Actividad:** Actividad 9 — Técnicas Estáticas de Prueba

---

## Prompt 1 — Generación del Checklist

**Prompt enviado:**

> Actúa como auditor de sistemas y experto en IEEE 1028.  
> Necesito un checklist de pruebas estáticas para auditar una aplicación C#.  
> El checklist debe evaluar:  
> - estándares de codificación  
> - seguridad básica  
> - mantenibilidad  
> - documentación  
> - buenas prácticas DevOps  
> Devuelve el checklist en formato Markdown con criterios claros y auditables.

**Respuesta IA:**

[IA generó un checklist detallado con 32 criterios distribuidos en 6 categorías, con columnas de Cumple/No Cumple y espacio para observaciones. El checklist incluye criterios auditables como la presencia de documentación XML, uso de TryParse, manejo de excepciones, y configuración CI/CD.]

---

## Prompt 2 — Generación del Script de Auditoría

**Prompt enviado:**

> Convierte los criterios del checklist anterior en reglas automatizables para un script PowerShell.  
> Cada regla debe:  
> - Analizar archivos .cs mediante análisis de texto (regex)  
> - Reportar ERROR o WARNING según la severidad  
> - Retornar exit code 1 si hay errores críticos (para bloquear el pipeline CI/CD)  
> - Exportar un reporte en texto plano

**Respuesta IA:**

[IA generó el script audit-script.ps1 con 7 reglas automatizadas que cubren seguridad (S-01, S-02), documentación (D-01, D-02), mantenibilidad (M-01), estándares (C-01, C-02), y manejo de excepciones (E-01). El script incluye salida con colores, resumen estadístico y export de reporte.]

---

## Prompt 3 — Configuración del Pipeline CI/CD

**Prompt enviado:**

> Genera un archivo GitHub Actions (audit.yml) que:  
> - Se ejecute en cada push y pull_request a main  
> - Ejecute el script PowerShell de auditoría  
> - Bloquee el merge si el script falla (exit code 1)  
> - Guarde el reporte como artefacto descargable  
> - Sea compatible con ubuntu-latest usando pwsh

**Respuesta IA:**

[IA generó el workflow audit.yml con 6 steps: checkout, verificación de PowerShell, ejecución del script, visualización del reporte en logs, guardado como artefacto, y verificación del exit code para bloquear merges fallidos.]

---

## Análisis Crítico del Uso de IA

La IA fue utilizada como herramienta de apoyo para:

1. **Agilizar la estructuración** del checklist con base en el estándar IEEE 1028, sugiriendo categorías y criterios que manualmente tomarían más tiempo de investigación.
2. **Traducir criterios cualitativos a reglas automáticas**, convirtiendo enunciados como "validar entradas del usuario" en patrones regex concretos (e.g., detectar `int.Parse` sin `TryParse`).
3. **Generar configuración DevOps** correcta para GitHub Actions, reduciendo errores de sintaxis YAML.

**Limitaciones identificadas:** La IA no puede ejecutar el código ni verificar que los patrones regex funcionan en todos los casos. El equipo validó manualmente cada regla contra el código de DemoAuditApp.