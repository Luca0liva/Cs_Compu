.equ SCREEN_WIDTH,    640
.equ SCREEN_HEIGHT,   480
.equ BITS_PER_PIXEL,  32

.equ GPIO_BASE,    0x3F200000
.equ GPIO_GPFSEL0, 0x00
.equ GPIO_GPLEV0,  0x34

.globl main
main:
    // X0 contiene la dirección base del framebuffer
    mov x19, x0    // Guardar la dirección base del framebuffer en x
    //Cuenta frames
    mov x5, 0
    //colores para usar
    movz x11, 0xE5, lsl 16   //Color cara 1
    movk x11, 0xC913, lsl 00
    movz x12, 0x33, lsl 16  //Color car 2
    movk x12, 0x0066, lsl 00
    movz x13, 0xFF, lsl 16  //Color ojos 1
    movk x13, 0xFFFF, lsl 00
    movz x14, 0xFF, lsl 16  //Color ojos 2
    movk x14, 0x0000, lsl 00
    movz x6, 0xE5, lsl 16  //Color dientes 1
    movk x6, 0xC913, lsl 00
    movz x16, 0xFF, lsl 16  //Color dientes 2
    movk x16, 0xFFFF, lsl 00
    movz x17, 0x6A, lsl 16  //Color fondo 1
    movk x17, 0xCAE8, lsl 00
    movz x18, 0x1E, lsl 16  //Color fondo 2
    movk x18, 0x610A, lsl 00
    movz x25, 0xFF, lsl 16  //Color fondo 1
    movk x25, 0x0000, lsl 00
    movz x26, 0x00, lsl 16  //Color fondo 2
    movk x26, 0xFF00, lsl 00

repeat:
    mov x0, x19
    mov x2, SCREEN_HEIGHT         // Tamaño Y
loop1:
    mov x1, SCREEN_WIDTH          // Tamaño X
loop0:
    // Calcular la distancia desde el punto actual al centro del círculo



    //circulo 1 (switch)
    mov x20, 80
    mov x21, 200
    mov x22, 150
    mov x10, x25
    bl _circle  

    //rectangulo 2 (switch)
    mov x20, 110
    mov x21, 250
    mov x22, 50
    mov x23, 150
    movz x10, 0xD8, lsl 16
    movk x10, 0xD3BF, lsl 00
    bl _rectangle

    //rectangulo 3 (marco dibujo)
    mov x20, 565
    mov x21, 400
    mov x22, 549
    mov x23, 35
    movz x10, 0x69, lsl 16
    movk x10, 0x420C, lsl 00
    bl _rectangle

    //rectangulo 4 (marco dibujo)
    mov x20, 550
    mov x21, 51
    mov x22, 245
    mov x23, 35
    movz x10, 0x69, lsl 16
    movk x10, 0x420C, lsl 00
    bl _rectangle

    //rectangulo 5 (marco dibujo)
    mov x20, 261
    mov x21, 415
    mov x22, 245
    mov x23, 35
    movz x10, 0x69, lsl 16
    movk x10, 0x420C, lsl 00
    bl _rectangle

    //rectangulo 4 (marco dibujo)
    mov x20, 565
    mov x21, 415
    mov x22, 245
    mov x23, 399
    movz x10, 0x69, lsl 16
    movk x10, 0x420C, lsl 00
    bl _rectangle

    //circulo 2.1 (iris izquierdo)
    mov x20, 450
    mov x21, 242
    mov x22, 300
    movz x10, 0x00, lsl 16
    movk x10, 0x0000, lsl 00
    bl _circle

    //circulo 2 (ojo izquierdo)
    mov x20, 450
    mov x21, 242
    mov x22, 1500
    mov x10, x13
    bl _circle

    //circulo 4 (iris derecho)
    mov x20, 360
    mov x21, 242
    mov x22, 300
    movz x10, 0x00, lsl 16
    movk x10, 0x0000, lsl 00
    bl _circle
    
    //circulo 3 (ojo derecho)
    mov x20, 360
    mov x21, 242
    mov x22, 1500
    mov x10, x13
    bl _circle

    //elipse 1 (sonrisa)
    mov x20, 405  //coordenada x 
    mov x21, 197  //coordenada y
    mov x22, 2    //horizontal
    mov x23, 1    //vertical
    mov x24, 1000    //size
    mov x10, x11
    bl _elipse

    //elipse 1 (sonrisa)
    mov x20, 405  //coordenada x 
    mov x21, 190  //coordenada y
    mov x22, 2    //horizontal
    mov x23, 1    //vertical
    mov x24, 900    //size
    movz x10, 0x00, lsl 16
    movk x10, 0x0000, lsl 00
    bl _elipse

    //elipse 1 (diente)
    mov x20, 405  //coordenada x 
    mov x21, 180  //coordenada y
    mov x22, 1    //horizontal
    mov x23, 2    //vertical
    mov x24, 300   //size
    mov x10, x6
    bl _elipse

    //elipse 1 (diente)
    mov x20, 435  //coordenada x 
    mov x21, 185  //coordenada y
    mov x22, 1    //horizontal
    mov x23, 2    //vertical
    mov x24, 300   //size
    mov x10, x6
    bl _elipse

    //elipse 1 (diente)
    mov x20, 375  //coordenada x 
    mov x21, 185  //coordenada y
    mov x22, 1    //horizontal
    mov x23, 2    //vertical
    mov x24, 300   //size
    mov x10, x6
    bl _elipse

    //circulo 1 (cabeza)
    mov x20, 405
    mov x21, 225
    mov x22, 12000
    mov x10, x11
    bl _circle  

    //rectangulo a (fondo dibujo)
    mov x20, 550
    mov x21, 400
    mov x22, 260
    mov x23, 50
    mov x10, x17
    bl _rectangle

    //FONDO 
    movz x10, 0x00, lsl 16
    movk x10, 0x1933, lsl 00
    b draw_pixel   

_circle:    //x^2+y^2<=r^2
    sub x3, x1, x20 // Posicion actual en X 
    mul x3, x3, x3  // x^2

    sub x4, x2, x21 // Posicion actual en Y
    mul x4, x4, x4  // y^2

    add x3, x3, x4  // x^2+y^2

    mov x4, x22
    sub x3, x3, x4  // Compara con r^2
    cmp x3, xzr      
    b.le draw_pixel // Dibuja ciculo si cumple la condicion
    ret             // Si no, retorna


_elipse:    //(x/a)^2+(y/b)^2<=c
    sub x3, x1, x20    // Posicion actual en X  
    udiv x3, x3, x22   // (x/a)
    mul x3, x3, x3     // (x/a)^2

    sub x4, x2, x21    // Posicion actual en Y 
    udiv x4, x4, x23   // (y/b)
    mul x4, x4, x4     // (y/b)^2

    add x3, x3, x4     // (x/a)^2+(y/b)^2

    mov x4, x24
    sub x3, x3, x4     // Compara con c
    cmp x3, xzr

    b.le draw_pixel    // Dibujar el píxel si se cumple la condición
    ret
        

_rectangle:
    str x20, [sp, #-8]!
    str x21, [sp, #-8]!
    str x0, [sp, #-8]!
    str x1, [sp, #-8]!

    str x30, [sp, #-8]!
    str x27, [sp, #-8]!   // Guardar el valor de retorno original

    sub x3, x1, x20  // Calcula la diferencia en el eje X
    sub x4, x2, x21  // Calcula la diferencia en el eje Y
    cmp x3, xzr      // Compara la diferencia en el eje X con cero
    b.ge skip_draw   // Salta si la diferencia en el eje X es menor que cero
    cmp x4, xzr      // Compara la diferencia en el eje Y con cero
    b.ge skip_draw   // Salta si la diferencia en el eje Y es menor que cero

    sub x3, x1, x22  // Calcula la diferencia en el eje X
    sub x4, x2, x23  // Calcula la diferencia en el eje Y
    cmp x3, xzr      // Compara la diferencia en el eje X con cero
    b.le skip_draw   // Salta si la diferencia en el eje X es mayor que cero
    cmp x4, xzr      // Compara la diferencia en el eje Y con cero
    b.le skip_draw   // Salta si la diferencia en el eje Y es mayor que cero

    // Restaurar los valores de los registros después del salto
    ldr x27, [sp], #8 // Restaurar el valor de retorno original
    ldr x30, [sp], #8

    ldr x1, [sp], #8
    ldr x0, [sp], #8
    ldr x21, [sp], #8
    ldr x20, [sp], #8
    b draw_pixel    //Dibujar el pixel si se cumple la condición


skip_draw:
    // Restaurar los valores de los registros antes de regresar
    ldr x27, [sp], #8   // Restaurar el valor de retorno original
    ldr x30, [sp], #8

    ldr x1, [sp], #8
    ldr x0, [sp], #8
    ldr x21, [sp], #8
    ldr x20, [sp], #8
    ret                 //Retornar al llamador



draw_pixel:
    stur w10, [x0]    // Establecer el color del píxel
next_pixel:
    add x0, x0, 4       // Siguiente píxel
    sub x1, x1, 1       // Decrementar el contador de X
    cbnz x1, loop0      // Si no es el final de la fila, saltar
    sub x2, x2, 1       // Decrementar el contador de Y
    cbnz x2, loop1      // Si no es la última fila, saltar

    add x5, x5, 1       //Incrementa el frame

    cmp x5, 3         // Cooldown de espacio a partir de los frames
    b.le repeat
check_key:
    mov x9, GPIO_BASE
    ldr w15, [x9, GPIO_GPLEV0] 

    and w27, w15, 0x02
    cmp w27, #0x02
    b.eq tecla_w        //0x3F20001C 0x2

    and w27, w15, 0x04
    cmp w27, #0x04
    b.eq tecla_a        //0x3F20001C 0x4

    and w27, w15, 0x08
    cmp w27, #0x08
    b.eq tecla_s        //0x3F20001C 0x8

    and w27, w15, 0x10
    cmp w27, #0x10
    b.eq tecla_d        //0x3F20001C 0x10

    and w27, w15, 0x20
    cmp w27, #0x20
    b.eq tecla_espacio  //0x3F20001C 0x20

    b end


tecla_w:
    b end
tecla_a:
    b end
tecla_s:
    b end
tecla_d:
    b end
tecla_espacio:
    mov x5, 0       //Reinicia cooldown de espacio
    //Cambio de color
    mov x7, x11
    mov x11, x12
    mov x12, x7
    mov x7, x13
    mov x13, x14
    mov x14, x7
    mov x7, x6
    mov x6, x16
    mov x16, x7
    mov x7, x17
    mov x17, x18
    mov x18, x7
    mov x7, x25
    mov x25, x26
    mov x26, x7
    b end


end:
    blt repeat
    b repeat


InfLoop:
    b InfLoop
