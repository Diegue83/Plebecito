# Bitácora TDD — Vota Dolores Hidalgo

**Autor:** [Diegue83](https://github.com/Diegue83)  
**Fecha:** 2026-11-18  
**Entorno:** Flutter 3.41.6 · Dart 3.11.4 · Windows 11  
**Comando usado en cada paso:** `flutter test test/servicio_votacion_test.dart --reporter expanded`

Cada fila corresponde a una ejecución real de las pruebas. La salida completa de la consola
quedó guardada en [`docs/evidencias/`](evidencias/) y cada paso tiene su propio commit en
la rama `tdd-rehecho`, firmado por Diegue83.

| Paso | Fase | Resultado | Motivo real del fallo / éxito | Evidencia | Commit |
|---|---|---|---|---|---|
| Ronda 1 | 🔴 Rojo | ❌ 0 pasan, 1 falla | Error de compilación: `ServicioVotacion` y `servicio_votacion.dart` no existen | [ronda1_rojo](evidencias/ronda1_rojo.txt) | `7d7ca31` |
| Ronda 1 | 🟢 Verde | ✅ 1/1 | `registrarVoto` mínimo (con `opcion!`) | [ronda1_verde](evidencias/ronda1_verde.txt) | `c0bf114` |
| Ronda 2 | 🔴 Rojo | ❌ 1 pasa, 1 falla | `Null check operator used on a null value` en `servicio_votacion.dart:15` (el `!` revienta con una opción inexistente) | [ronda2_rojo](evidencias/ronda2_rojo.txt) | `e877eea` |
| Ronda 2 | 🟢 Verde | ✅ 2/2 | Se regresa `opcionInvalida` si la opción es `null` | [ronda2_verde](evidencias/ronda2_verde.txt) | `f70c005` |
| Ronda 3 | 🔴 Rojo | ❌ 2 pasan, 1 falla | `Expected: usuarioYaVoto` / `Actual: exitoso`: el segundo voto del mismo usuario se aceptó | [ronda3_rojo](evidencias/ronda3_rojo.txt) | `2f2498b` |
| Ronda 3 | 🟢 Verde | ✅ 3/3 | Se registra el usuario en `votantes` y se valida antes de votar | [ronda3_verde](evidencias/ronda3_verde.txt) | `8e8e236` |
| Ronda 4 | 🔴 Rojo | ❌ compilación | `The method 'obtenerResultados' isn't defined for the type 'ServicioVotacion'` | [ronda4_rojo](evidencias/ronda4_rojo.txt) | `50f6309` |
| Ronda 4 | 🟢 Verde | ✅ 5/5 | `obtenerResultados()` con protección contra la división entre cero | [ronda4_verde](evidencias/ronda4_verde.txt) | `c0b4890` |
| Ronda 5 | 🔴 Rojo | ❌ compilación | `The method 'determinarGanador' isn't defined for the type 'ServicioVotacion'` | [ronda5_rojo](evidencias/ronda5_rojo.txt) | `a965704` |
| Ronda 5 | 🟢 Verde | ✅ 6/6 | `determinarGanador()` con `where` sobre el máximo | [ronda5_verde](evidencias/ronda5_verde.txt) | `c9253d7` |
| Ronda 6 | ⚪ Sin rojo | ✅ 7/7 | La prueba de empate pasó **a la primera** sin cambiar código: `where()` ya regresaba todas las opciones empatadas. Se conserva como prueba de regresión | [ronda6_sin_rojo](evidencias/ronda6_sin_rojo.txt) | `778745b` |
| Ronda 7 | 🔴 Rojo | ❌ 8 pasan, 1 falla | `Expected: votacionCerrada` / `Actual: exitoso`: se aceptó un voto en una votación cerrada en el año 2000. La prueba "sigue abierta" sí pasó | [ronda7_rojo](evidencias/ronda7_rojo.txt) | `1d56d76` |
| Ronda 7 | 🟢 Verde | ✅ 9/9 | Validación de `fechaCierre` con `DateTime.now()` | [ronda7_verde](evidencias/ronda7_verde.txt) | `a5aaac7` |
| Ronda 8 | 🔵 Refactor | ✅ 9/9 | Guard clauses con nombres (`yaCerro`, `yaVoto`); el comportamiento no cambió | [ronda8_refactor](evidencias/ronda8_refactor.txt) | `0f04df0` |
| Integración | ⚪ Sin rojo | ✅ 10/10 | El plebiscito completo con voto duplicado pasa sin código nuevo | [integracion](evidencias/integracion.txt) | `275b786` |

## Resumen

- **Ejecuciones totales:** 15 (6 en rojo, 9 en verde)
- **Pruebas finales:** 10 en verde
- **Análisis estático (`flutter analyze`):** sin problemas

### Nota sobre el número de pruebas
El manual dice que "deberían pasar 9 pruebas", pero si se cuentan las pruebas que escribe, son **10**:
las rondas 4 y 7 tienen dos pruebas cada una (1+1+1+2+1+1+2 = 9) más la de integración. La versión
anterior del proyecto tenía 9 porque **le faltaba la prueba de la Ronda 3** ("un mismo usuario no puede
votar dos veces"). Ahora sí está.

## Cómo repetir las pruebas en VS Code
`Ctrl+Shift+P` → **Tasks: Run Task** → elige `TDD: todas las pruebas` o una prueba individual
(`TDD: Ronda 1`, `TDD: Ronda 2`, …). También puedes usar la vista **Testing** (ícono del matraz)
con la extensión de Flutter.
