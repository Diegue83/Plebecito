# Ejecuta, en orden, cada paso del ciclo TDD (rojo / verde / refactor).
# Cada ejecucion regresa lib/ y test/ al commit de ese paso, corre la prueba
# real con flutter test y avanza al siguiente. Uso desde VS Code:
#   Ctrl+Shift+B                -> siguiente paso
#   Run Task "TDD: reiniciar"   -> vuelve al paso 1 y deja el codigo final
param([switch]$Reiniciar)

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)
$estado = '.dart_tool/tdd_paso_actual.txt'

$pasos = @(
  @{c='7d7ca31'; t='Ronda 1 - ROJO';                  n='registrar un voto valido'},
  @{c='c0bf114'; t='Ronda 1 - VERDE';                 n='registrar un voto valido'},
  @{c='e877eea'; t='Ronda 2 - ROJO';                  n='opcion que no existe'},
  @{c='f70c005'; t='Ronda 2 - VERDE';                 n='opcion que no existe'},
  @{c='2f2498b'; t='Ronda 3 - ROJO';                  n='no puede votar dos veces'},
  @{c='8e8e236'; t='Ronda 3 - VERDE';                 n='no puede votar dos veces'},
  @{c='50f6309'; t='Ronda 4 - ROJO';                  n='porcentaje|ningun voto'},
  @{c='c0b4890'; t='Ronda 4 - VERDE';                 n='porcentaje|ningun voto'},
  @{c='a965704'; t='Ronda 5 - ROJO';                  n='opcion con mas votos'},
  @{c='c9253d7'; t='Ronda 5 - VERDE';                 n='opcion con mas votos'},
  @{c='778745b'; t='Ronda 6 - PASA A LA PRIMERA';     n='empate'},
  @{c='1d56d76'; t='Ronda 7 - ROJO';                  n='ya cerro|sigue abierta'},
  @{c='a5aaac7'; t='Ronda 7 - VERDE';                 n='ya cerro|sigue abierta'},
  @{c='0f04df0'; t='Ronda 8 - REFACTOR (todas)';      n=''},
  @{c='275b786'; t='Integracion - PASA A LA PRIMERA'; n='simulacion completa'},
  @{c='HEAD';    t='Suite final completa';            n=''}
)

if ($Reiniciar) {
  git restore --source=HEAD --worktree -- lib test
  git checkout HEAD -- lib test
  Set-Content $estado '0'
  Write-Host 'Listo: el siguiente paso sera el 1. El codigo quedo en su version final.' -ForegroundColor Cyan
  exit 0
}

$i = 0
if (Test-Path $estado) { $i = [int](Get-Content $estado) }
if ($i -ge $pasos.Count) { $i = 0 }
$p = $pasos[$i]

git restore --source=$($p.c) --worktree -- lib test
$info = git log -1 --format='%h  |  autor: %an  |  %ad  |  %s' --date=format:'%Y-%m-%d %H:%M' $p.c

Write-Host '================= VOTA DOLORES HIDALGO - TDD =================' -ForegroundColor Cyan
Write-Host (' Paso {0}/{1} : {2}' -f ($i + 1), $pasos.Count, $p.t) -ForegroundColor Yellow
Write-Host " Commit     : $info" -ForegroundColor Yellow
Write-Host " Usuario git: $(git config user.name)" -ForegroundColor Yellow
Write-Host '==============================================================' -ForegroundColor Cyan

$cmd = @('test', 'test/servicio_votacion_test.dart', '--reporter', 'expanded', '--no-pub')
if ($p.n) { $cmd += @('--name', $p.n) }
Write-Host ''
Write-Host ("PS $(Get-Location)> flutter " + (($cmd | ForEach-Object { if ($_ -match ' |\|') { "`"$_`"" } else { $_ } }) -join ' '))
& flutter @cmd
$code = $LASTEXITCODE

Write-Host ''
if ($code -eq 0) { Write-Host " Codigo de salida: $code  (PASA)" -ForegroundColor Green }
else             { Write-Host " Codigo de salida: $code  (FALLA)" -ForegroundColor Red }

$sig = $i + 1
if ($sig -ge $pasos.Count) {
  git checkout HEAD -- lib test
  Set-Content $estado '0'
  Write-Host ' Fue el ultimo paso; el codigo quedo en su version final.' -ForegroundColor Cyan
} else {
  Set-Content $estado "$sig"
}
exit 0
