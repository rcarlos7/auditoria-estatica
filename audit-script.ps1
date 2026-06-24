# =============================================================
# audit-script.ps1
# Auditoría Estática Automatizada — IEEE 1028
# Proyecto: DemoAuditApp
# =============================================================

param(
    [string]$SourcePath = "./DemoAuditApp",
    [string]$ReportOutput = "./audit-report-auto.txt"
)

$ErrorCount = 0
$WarningCount = 0
$Results = @()

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  AUDITORÍA ESTÁTICA IEEE 1028 — DemoAuditApp" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# -----------------------------------------------
# FUNCIÓN: Registrar hallazgo
# -----------------------------------------------
function Register-Finding {
    param(
        [string]$Category,
        [string]$Rule,
        [string]$Severity,
        [string]$Detail
    )
    $script:Results += [PSCustomObject]@{
        Categoria  = $Category
        Regla      = $Rule
        Severidad  = $Severity
        Detalle    = $Detail
    }
    if ($Severity -eq "ERROR") { $script:ErrorCount++ }
    if ($Severity -eq "WARNING") { $script:WarningCount++ }

    $color = if ($Severity -eq "ERROR") { "Red" } elseif ($Severity -eq "WARNING") { "Yellow" } else { "Green" }
    Write-Host "[$Severity] [$Category] $Rule" -ForegroundColor $color
    Write-Host "         $Detail" -ForegroundColor Gray
}

# -----------------------------------------------
# Obtener archivos C# a auditar
# -----------------------------------------------
$CSharpFiles = Get-ChildItem -Path $SourcePath -Filter "*.cs" -Recurse
Write-Host "Archivos C# encontrados: $($CSharpFiles.Count)" -ForegroundColor White
Write-Host ""

foreach ($file in $CSharpFiles) {
    $content = Get-Content $file.FullName -Raw
    $lines   = Get-Content $file.FullName
    $fname   = $file.Name

    Write-Host "--- Auditando: $fname ---" -ForegroundColor Magenta

    # -----------------------------------------------
    # REGLA S-01: Validación de entrada (int.Parse sin TryParse)
    # -----------------------------------------------
    if ($content -match "int\.Parse\s*\(") {
        Register-Finding "Seguridad" "S-01" "ERROR" "$fname usa int.Parse() sin validación. Usar int.TryParse() para entradas del usuario."
    }

    # -----------------------------------------------
    # REGLA S-02: Console.ReadLine() sin null check
    # -----------------------------------------------
    if ($content -match "Console\.ReadLine\(\)") {
        Register-Finding "Seguridad" "S-02" "WARNING" "$fname usa Console.ReadLine() sin validar si el resultado es null."
    }

    # -----------------------------------------------
    # REGLA E-01: Manejo de excepciones ausente
    # -----------------------------------------------
    if ($content -notmatch "try\s*\{" -and $content -match "Parse|Convert\.|File\.|Stream") {
        Register-Finding "Buenas Prácticas" "E-01" "ERROR" "$fname no implementa bloques try-catch para operaciones riesgosas."
    }

    # -----------------------------------------------
    # REGLA D-01: Documentación XML ausente
    # -----------------------------------------------
    if ($content -notmatch "///\s*<summary>") {
        Register-Finding "Documentación" "D-01" "WARNING" "$fname no contiene documentación XML (/// <summary>)."
    }

    # -----------------------------------------------
    # REGLA D-02: Sin comentarios en lógica compleja
    # -----------------------------------------------
    $commentLines = ($lines | Where-Object { $_ -match "^\s*//" }).Count
    if ($commentLines -eq 0) {
        Register-Finding "Documentación" "D-02" "WARNING" "$fname no tiene ningún comentario explicativo."
    }

    # -----------------------------------------------
    # REGLA M-01: Logging ausente
    # -----------------------------------------------
    if ($content -notmatch "ILogger|Log\.|Serilog|NLog|Console\.Write") {
        Register-Finding "Mantenibilidad" "M-01" "WARNING" "$fname no implementa ningún mecanismo de logging."
    }

    # -----------------------------------------------
    # REGLA C-01: Números mágicos
    # -----------------------------------------------
    if ($content -match "(?<![a-zA-Z_])\b(18|100|200|500|1000)\b(?![a-zA-Z_])") {
        Register-Finding "Estándares" "C-01" "WARNING" "$fname contiene posibles números mágicos. Considerar constantes nombradas."
    }

    # -----------------------------------------------
    # REGLA C-02: Lógica de negocio en Main()
    # -----------------------------------------------
    if ($content -match "static void Main" -and $content -match "if\s*\(") {
        Register-Finding "Estándares" "C-02" "WARNING" "$fname contiene lógica de negocio dentro de Main(). Separar en métodos o clases."
    }

    Write-Host ""
}

# -----------------------------------------------
# RESUMEN FINAL
# -----------------------------------------------
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  RESUMEN DE AUDITORÍA" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Errores encontrados:    $ErrorCount" -ForegroundColor Red
Write-Host "Advertencias:           $WarningCount" -ForegroundColor Yellow
Write-Host "Total hallazgos:        $($Results.Count)" -ForegroundColor White

# -----------------------------------------------
# EXPORTAR REPORTE
# -----------------------------------------------
$reportLines = @(
    "# Reporte de Auditoría Automática — IEEE 1028",
    "Fecha: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "Errores: $ErrorCount | Advertencias: $WarningCount",
    "",
    "## Hallazgos"
)

foreach ($r in $Results) {
    $reportLines += "- [$($r.Severidad)] [$($r.Categoria)] $($r.Regla): $($r.Detalle)"
}

$reportLines | Out-File -FilePath $ReportOutput -Encoding UTF8
Write-Host ""
Write-Host "Reporte exportado en: $ReportOutput" -ForegroundColor Green

# -----------------------------------------------
# EXIT CODE para CI/CD (falla el pipeline si hay errores)
# -----------------------------------------------
if ($ErrorCount -gt 0) {
    Write-Host ""
    Write-Host "AUDITORÍA FALLIDA — $ErrorCount error(es) crítico(s) encontrado(s)." -ForegroundColor Red
    exit 1
} else {
    Write-Host ""
    Write-Host "AUDITORÍA COMPLETADA — Sin errores críticos." -ForegroundColor Green
    exit 0
}