# vota_dolores_hidalgo

### Ejecución de pruebas

![alt text](image.png)

### Prueba en dispositivo

| ![alt text](image-1.png) | ![alt text](image-2.png) | ![alt text](image-3.png) |
| :---: | :---: | :---: |

### Verificación

| Verificación | Estado |
| ------------ | :----: |
| Cada regla de negocio (voto único, opción válida, fecha de cierre, empates) tiene su propia prueba | ✓ |
| ResultadoVoto se usa para casos esperados; no se abusa de excepciones para control de flujo normal | ✓ |
| obtenerResultados() no puede dividir entre cero cuando no hay votos | ✓ |
| La interfaz (VotacionScreen) no duplica ninguna regla ya cubierta por ServicioVotacion | ✓ |
| Existe una prueba de integración que simula un plebiscito completo, incluyendo un intento de voto duplicado | ✓ |