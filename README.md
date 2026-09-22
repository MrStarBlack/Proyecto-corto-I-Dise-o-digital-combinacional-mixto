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

### 3.1 Oscilador de anillo
Para el primer caso con 5 inversores:  Se armó un oscilador de anillo con 5 inversores del 74HC04 en cascada, con la salida del último realimentada a la entrada del primero. Con un número impar de etapas, el circuito no tiene un punto de equilibrio estable y comienza a oscilar espontáneamente. Cada ciclo completo de oscilación requiere que la señal recorra las N etapas dos veces (ya que tras N inversiones con N impar la señal queda invertida respecto a su estado inicial, y se necesita una segunda vuelta para restaurarla), de modo que el período total T se relaciona con el retardo de propagación promedio de cada inversor tPD mediante T = 2·N·tPD. Con el osciloscopio se midió una frecuencia de oscilación de 94.79 MHz, equivalente a un período T = 10.55 ns. Despejando: tPD = T/ (2·5) = 1.055 ns. Este valor representa el tiempo de propagación promedio (entre tPLH y tPHL) de un único inversor 74HC04 en las condiciones reales de esta implementación en protoboard.
<img width="800" height="480" alt="Caso1" src="https://github.com/user-attachments/assets/e41c289d-46a2-472d-980d-b7be9f402d82" />
Para el segundo caso de 3 inversores: Se reconfiguró el circuito para implementar un oscilador de anillo con 3 inversores en cascada. Al tratarse de un número impar de etapas (N = 3), el período total T se relaciona con el retardo de propagación mediante la expresión T = 2NtpD= 6tpD, despejándose como tpD = T / 6. Teóricamente, al reducir las etapas de 5 a 3, el camino de propagación del lazo se acorta, lo que debería resultar en un período menor y una frecuencia de oscilación superior a los 94.79 MHz obtenidos previamente con 5 inversores. Al realizar el real alambrado y medir con el osciloscopio, se registró una frecuencia de conmutación de alta velocidad de 86.58 MHz (esto pudo deberse por acoplamientos de ruido ambiental debido a la sensibilidad de los nodos flotantes). 
<img width="800" height="480" alt="Caso2_3inv" src="https://github.com/user-attachments/assets/fca9a7e9-5e81-4848-b04a-bd9e43e57ab7" />
Caso de los 3 inversores con cable de 1 metro: Al insertar una pieza de alambre de aproximadamente 1 metro en el lazo del anillo de 3 inversores, se observó un cambio radical en la señal. La capacitancia y la inductancia añadida por el cable aumentaron mucho la constante de tiempo, colapsando por completo la oscilación natural. En la pantalla del osciloscopio se midió una frecuencia de 48.63 Hz, lo que demuestra que el tramo largo dejó de propagar la conmutación lógica y pasó a comportarse como una antena. 
<img width="800" height="480" alt="Caso3_1metro" src="https://github.com/user-attachments/assets/4be9b429-8660-447f-886b-1267417a1eea" />
Caso de inversor con capacitor: Este caso no se pudo lograr ya que el circuito dejó de oscilar y el instrumento pasó a capturar únicamente el ruido del osciloscopio a pesar de usar un capacitor cerámico de 0.1 µF. La señal de salida hubiera significado que el tiempo que le toma a la tensión de salida cruzar el umbral de conmutación (pasar de 0 a 1 lógico) del siguiente inversor representaría directamente el retraso adicional introducido por la constante de tiempo del capacitor. Esto permitiría calcular de forma experimental cómo una mayor capacitancia de carga desacelera el circuito además de ver que efectivamente la onda se ve más estable con un capacitor.
<img width="800" height="480" alt="Caso5" src="https://github.com/user-attachments/assets/c58ab8d2-0416-487c-8a0c-bb4aa057260c" />


### 3.2 Módulo 1
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

Post-Síntsis Corrección de error:
<img width="1539" height="683" alt="image" src="https://github.com/user-attachments/assets/38977b21-dd1c-4d85-8cf6-1d407c58eb35" />

Post-Síntesis display 7 segmentos Transmisor:
<img width="1543" height="654" alt="WhatsApp Image 2026-09-22 at 3 17 05 AM" src="https://github.com/user-attachments/assets/353c28c2-d843-4bde-bafb-09a026adea98" />

Post-Síntesis Inyección del error
<img width="1526" height="656" alt="WhatsApp Image 2026-09-22 at 3 22 30 AM" src="https://github.com/user-attachments/assets/288e26ae-95c8-4e65-8fbd-966693e7bd4c" />

Post-Síntesis Sindrome
<img width="1550" height="696" alt="WhatsApp Image 2026-09-22 at 3 30 06 AM" src="https://github.com/user-attachments/assets/04b7f86f-d292-4067-b06a-262624a188ba" />

Post-Síntesis Correción de error
<img width="1600" height="962" alt="WhatsApp Image 2026-09-22 at 3 32 47 AM" src="https://github.com/user-attachments/assets/09884592-1f67-4b27-a17e-cedc1c35c84e" />

Post-Síntesis Decodificador de Paridad
<img width="1600" height="962" alt="WhatsApp Image 2026-09-22 at 3 32 47 AM" src="https://github.com/user-attachments/assets/544654f7-3713-4a42-bebf-ef1cbb97213a" />

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

