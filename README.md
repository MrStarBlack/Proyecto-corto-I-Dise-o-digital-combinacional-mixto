# Proyecto-corto-I-Dise-o-digital-combinacional-mixto
Primer Proyecto de Diseño lógico de la creación de un transmisor y un receptor con el algoritmo de Hamming, para la corrección de una palabra transmitida con error (SEC), y la detección de una palabra con dos errores (DED).
# Proyecto corto I: Diseño digital combinacional mixto

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## 3. Desarrollo

### 3.0 Descripción general del sistema
El proyecto consiste en el diseño e implementación de un sistema digital de transmisión y recepción de datos capaz de detectar y corregir errores utilizando el código Hamming extendido, conocido como SECDED (Single Error Correction, Double Error Detection).

El objetivo principal del sistema es recibir una palabra de datos, generar una versión codificada que incluya los bits de paridad necesarios, simular la transmisión de esta palabra y posteriormente analizar la información recibida para determinar si se produjo algún error. En caso de existir un error de un solo bit, el sistema identifica su posición y realiza la corrección correspondiente. Además, el sistema permite visualizar el estado del proceso mediante los LEDs de la FPGA y representar información binaria en formato hexadecimal mediante un display de siete segmentos.

Para facilitar el diseño y la verificación, el sistema se dividió en diferentes bloques funcionales. Cada bloque realiza una tarea específica y posteriormente sus señales son conectadas mediante el módulo superior del proyecto.
De manera paralela, la información necesaria para la visualización es enviada al conversor de binario a hexadecimal y posteriormente al display de siete segmentos.

1) Codificador (palabra correcta)
Entrada: una palabra binaria de 4 bits, seleccionada mediante interruptores de 4 switch [datos_i[3];,datos_i[2]; datos_i[1]; datos_i[0];
Se calculan tres bits de paridad (I1,I2,I3) utilizando compuertas XOR, permitiendo que se calcule un bit de paridad global P
Se forma una palabra de 8 bits en formato: [D0, D1, D2, D3, I1, I2, I3, P] correspondiente al Hamming (7,4) codificado.  
En la salida se forma una palabra de 8 bits que corresponde al síndrome de la palabra codificada. En formato: [D0, D1, D2, D3, I1, I2, I3, P]

2) Receptor: (palabra codificada recibida)
Entrada: Palabra de 8 bits correspondiente a la palabra recibida con el mismo formato del Hamming codificado: [D0, D1, D2, D3, I1, I2, I3, P] del interruptor de 8 switch. Este módulo recalcula el síndrome de la palabra recibida utilizando las paridades ingresadas en la palabra. De modo que solo se recalcula la paridad global [P] de la palabra recibida. De modo que el único caso de error que excluye este código corresponde al error en bit global.
Salida: Corrección de la palabra transmitida y visualización en el display de binario a Hexadecimal 

3) Comparador:
Entrada: Síndrome de la palabra codificada y transmitida.
Procesamiento: 
Con compuertas XOR se comparan ambos síndromes de modo que se obtienen una coordenada en binario de la posición del error en la palabra recibida.
Casos:
Síndrome = 000 → no hay error detectado en los 7 bits principales, excluye bit global.
Si el síndrome ≠ 000 → indica la posición del bit con error.
Se revisa el bit de paridad global G0:
Si síndrome ≠ 000 y G0 falla → se corrige un error de 1 bit en la posición indicada.
Si síndrome = 000 y G0 falla → se detecta un error de 2 bits (DED) que no puede corregirse.
Salida: la posición de error que corresponde los bits comparados [eG, e2, e1, e0].

4) Corrector
Receptor: (palabra codificada recibida)
Entrada: Palabra de 8 bits correspondiente a la palabra recibida con el mismo formato del Hamming codificado: [D0, D1, D2, D3, I1, I2, I3, P] del interruptor de 8 switch.
procedimiento:
 Este módulo recalcula el síndrome de la palabra recibida utilizando las paridades ingresadas en la palabra. De modo que solo se recalcula la paridad global [P] de la palabra recibida. De modo que el único caso de error que excluye este código corresponde al error en bit global. Esta palabra hace que los bits del receptor sean corregidos utilizando el síndrome de Hamming para identificar la posición del bit erróneo y luego invertirlo mediante una operación XOR.
Salida: Corrección de la palabra transmitida y visualización en el display de binario a Hexadecimal.

5) Leds de la FPGA
Recibe la palabra corregida y enciende los leds de la FPGA invirtiendo los bits.

6) Conversor de Binario a Hexadecimal
Entradas: Palabra corregida de 8 bits
Procedimiento:
Realmente este modulo pasa de binario a otro número en binario que según ese orden enciende los siete LEDS del segmento en forma hexadecimal. 
Salida: Palabra corregida ilustrada en el display de siete segmentos.


### 3.1 Módulo 1
#### 1. Encabezado del módulo
```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```
#### 2. Parámetros


#### 3. Entradas y salidas:
- `entrada_i`: La entrada es proporcionada por el usuario correspondiente a los cuatro bits de la palaba para el primer subsistema. Para el segundo subsistema se recibe de entrada la palabra de 8 bits la cual se le inyecta el error. Para el receptor, el primer subsistema recibe la palabra de 8 bits codificada con el error o sin el, luego recibe los 7 bits de hamming sin el bit de paridad global, el siguiente recibe los 7 bits con la corrección y finalmente el ultimo subsistema recibe la palabra de 4 bits para mostrarla en el display.
- `salida_o`: La salida del primer módulo de transmisión es la palabra hexadecimal de la palabra original de 4 bits que el usuario introdujo, para el segundo subsistema se envía la palabra de 8 bits al receptor (4 bits correspondientes a D0,D1,D2,D3, 3 bits de paridad P1,P2,P3 y un octavo bit de paridad global P). Para el primer subsistema del receptor da como salida los 7 bits sin la paridad global, después para el segundo subsistema la salida de este son los 7 bits pero con la posición del error, luego la salida para el tercer subsistema es la palabra ya corregida y puesta en el display 7 segmentos. 

#### 4. Criterios de diseño
Para el diseño del proyecto se priorizó la funcionalidad antes que la estética, sin embargo también está en duda, debido a los constantes problemas que se tuvieron para implementar las herramientas. Se priorizó completar el transmisor debido a que es la parte más complicada de hacer y luego se realizó el receptor.
#### 5. Testbench
<img width="862" height="795" alt="WhatsApp Image 2026-09-22 at 2 15 17 AM" src="https://github.com/user-attachments/assets/86b6536a-04af-46b5-8a10-da25e19b4248" />

<img width="508" height="391" alt="WhatsApp Image 2026-09-22 at 1 49 29 AM" src="https://github.com/user-attachments/assets/22647979-52ba-4728-a3d7-ca6215c6353b" />

<img width="1044" height="803" alt="WhatsApp Image 2026-09-22 at 1 51 23 AM" src="https://github.com/user-attachments/assets/713ffbd8-7ffd-4836-ac25-b5531ad07814" />

<img width="521" height="236" alt="WhatsApp Image 2026-09-22 at 1 51 55 AM" src="https://github.com/user-attachments/assets/5116208e-96a6-4e96-8113-7db94ee3a146" />

<img width="916" height="810" alt="WhatsApp Image 2026-09-22 at 1 52 47 AM" src="https://github.com/user-attachments/assets/ac57362e-70e3-4c9b-bf63-f5fbc8d338ec" />

<img width="319" height="802" alt="WhatsApp Image 2026-09-22 at 1 57 45 AM" src="https://github.com/user-attachments/assets/bc3e291a-4298-4b4f-b38a-09153ab8c644" />


## 4. Consumo de recursos

## 5. Problemas encontrados durante el proyecto
Literalmente todo. Desde la implementación de las herramientas hasta la realización del código nos hemos encontrado con demasiadas dificultades. La más importante es con la programación en Visual Studio ya que tuvimos demasiados problemas para implementar todas las herramientas necesarias, debido a que se necesitó ayuda extra del tutor para poder implementarlas. El armado del circuito fue otro problema bastante mayor ya que al tener muchos componentes además de no salir barato tomaba mucho tiempo intentarlo acomodar bien y que no se hicieran falsos contactos. 
## Apendices:
### Apendice 1:
Con esto se puede calcular el tiempo de propagación promedio del inversor TTL;
Para el caso de los 5 inversores:
T = 2·N·tPD
T = 10.55 ns y N=5:

tPD = T/ (2·5) = 1.055 ns

### Apendice 2 (Bitácoras):
<img width="1080" height="1290" alt="bitacora1" src="https://github.com/user-attachments/assets/711ad037-9074-482b-852c-460b713fa12f" />
<img width="1332" height="1600" alt="WhatsApp Image 2026-09-22 at 1 58 21 AM" src="https://github.com/user-attachments/assets/62c3d7ae-0a5f-4de0-bb6d-7bdeadba52d2" />
<img width="1309" height="1600" alt="WhatsApp Image 2026-09-22 at 1 58 36 AM" src="https://github.com/user-attachments/assets/8eaf5f80-9cc5-4be6-8ade-17e04e8a0699" />
<img width="1060" height="1458" alt="WhatsApp Image 2026-09-22 at 1 58 55 AM" src="https://github.com/user-attachments/assets/3158d8d3-7af5-4ee6-82ab-307a2064edd5" />
<img width="905" height="1350" alt="WhatsApp Image 2026-09-22 at 1 59 16 AM" src="https://github.com/user-attachments/assets/5253244f-3a21-445b-a35f-47c44271d309" />

