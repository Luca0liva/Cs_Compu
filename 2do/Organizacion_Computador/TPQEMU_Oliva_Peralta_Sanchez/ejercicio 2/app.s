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
    //---------------- CODE HERE ------------------------------------
    
    //Panel actual
    mov x5, 0
    //Controles
    mov x11, 1 //Si == xzr, no se toma e cuenta wasd y espacio
    //Posicion jugador y en panel5 para animacion
    mov x6, SCREEN_WIDTH/2      //X
    mov x7, SCREEN_HEIGHT/2     //Y
    //Posicion bola de cañon
    mov x25, SCREEN_WIDTH
    mov x26, SCREEN_HEIGHT / 2
    //Cuenta el frame
    mov x12, 0
repeat:
    mov x0, x19
    mov x2, SCREEN_HEIGHT         // Tamaño Y
loop1:
    mov x1, SCREEN_WIDTH          // Tamaño X
loop0:
    //Selecciona el panel
    cmp x5, 0
    b.eq panel0

    cmp x5, 1
    b.eq panel1

    mov x11, xzr // Desactiva check_key para la animacion
    
    cmp x5, 2
    b.eq panel2

    cmp x5, 3
    b.eq panel3

    cmp x5, 4
    b.eq panel4

    cmp x5, 5
    b.eq panel5

    cmp x5, 6
    b.eq panel6

    cmp x5, 7
    b.eq panel7

panel0:
    //Rueda (elipse)
    mov x20, x6     //coordenada x
    sub x21, x7, 20 //coordenada y
    mov x22, 2      //horizontal
    mov x23, 1      //vertical
    mov x24, 400    //size
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _elipse
    

    //Rueda (elipse)
    mov x20, x6     //coordenada x
    sub x21, x7, 20 //coordenada y
    mov x22, 2      //horizontal
    mov x23, 1      //vertical
    mov x24, 700    //size
    movz x10, 0x00, lsl 16
    movk x10, 0x0000, lsl 00
    bl _elipse
    

    //Tanque (rectangulo) 
    add x20, x6, 45
    add x21, x7, 30
    sub x22, x6, 45
    sub x23, x7, 30
    movz x10, 0x33, lsl 16
    movk x10, 0x6600, lsl 00
    bl _rectangle

    //Punta del cañon (rectangulo)
    sub x20, x6, 79
    add x21, x7, 26
    sub x22, x6, 85
    add x23, x7, 9
    movz x10, 0x00, lsl 16
    movk x10, 0x0000, lsl 00
    bl _rectangle

    //Cañon (rectangulo)
    add x20, x6, 45
    add x21, x7, 23
    sub x22, x6, 80
    add x23, x7, 12
    movz x10, 0x33, lsl 16
    movk x10, 0x6600, lsl 00
    bl _rectangle


    //FONDO 
    movz x10, 0x4B, lsl 16
    movk x10, 0x2700, lsl 00
    b draw_pixel   
     
panel1:
    //genera mira del cañon
    mov x20, x6
    mov x21, x7
    mov x22, 8000
    movz x10, 0x00, lsl 16
    movk x10, 0x0000, lsl 00
    bl _r_circle

    //Puerta (rectangulo)
    mov x20, 360
    mov x21, 120
    mov x22, 280
    mov x23, 50
    movz x10, 0x4B, lsl 16
    movk x10, 0x2700, lsl 00
    bl _rectangle
    
    //Castillo 1 (rectangulo)
    mov x20, 540
    mov x21, 200
    mov x22, 100
    mov x23, 50
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Castillo 2 (rectangulo)
    mov x20, 540
    mov x21, 250
    mov x22, 485
    mov x23, 199
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Castillo 3 (rectangulo)
    mov x20, 440
    mov x21, 250
    mov x22, 385
    mov x23, 199
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Castillo 4 (rectangulo)
    mov x20, 255
    mov x21, 250
    mov x22, 200
    mov x23, 199
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Castillo 5 (rectangulo)
    mov x20, 155
    mov x21, 250
    mov x22, 100
    mov x23, 199
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Castillo 6 (rectangulo)
    mov x20, 343
    mov x21, 250
    mov x22, 297
    mov x23, 199
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle


    //Torre (rectangulo)
    mov x20, 400
    mov x21, 400
    mov x22, 240
    mov x23, 199
    movz x10, 0x2F, lsl 16
    movk x10, 0x2F2F, lsl 00
    bl _rectangle

    //Pasto (rectangulo)
    mov x20, 640
    mov x21, 100
    mov x22, 0
    mov x23, 0
    movz x10, 0x33, lsl 16
    movk x10, 0x6600, lsl 00
    bl _rectangle

    //Cielo (Fondo)
    movz x10, 0x4B, lsl 16
    movk x10, 0xFFFF, lsl 00
    b draw_pixel   

panel2:
    //Rueda (elipse)
    mov x20, x6     //coordenada x
    sub x21, x7, 20 //coordenada y
    mov x22, 2      //horizontal
    mov x23, 1      //vertical
    mov x24, 400    //size
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _elipse
    

    //Rueda (elipse)
    mov x20, x6     //coordenada x
    sub x21, x7, 20 //coordenada y
    mov x22, 2      //horizontal
    mov x23, 1      //vertical
    mov x24, 700    //size
    movz x10, 0x00, lsl 16
    movk x10, 0x0000, lsl 00
    bl _elipse
    

    //Tanque (rectangulo) 
    add x20, x6, 45
    add x21, x7, 30
    sub x22, x6, 45
    sub x23, x7, 30
    movz x10, 0x33, lsl 16
    movk x10, 0x6600, lsl 00
    bl _rectangle

    //Punta del cañon (rectangulo)
    sub x20, x6, 79
    add x21, x7, 26
    sub x22, x6, 85
    add x23, x7, 9
    movz x10, 0x00, lsl 16
    movk x10, 0x0000, lsl 00
    bl _rectangle

    //Cañon (rectangulo)
    add x20, x6, 45
    add x21, x7, 23
    sub x22, x6, 80
    add x23, x7, 12
    movz x10, 0x33, lsl 16
    movk x10, 0x6600, lsl 00
    bl _rectangle

    //Humo
    sub x20, x6, 90
    add x21, x7, 28
    mov x22, 800
    movz x10, 0xC0, lsl 16
    movk x10, 0xC0C0, lsl 00
    bl _circle

    //Humo
    sub x20, x6, 90
    add x21, x7, 5
    mov x22, 800
    movz x10, 0xE0, lsl 16
    movk x10, 0xE0E0, lsl 00
    bl _circle

    //Humo
    sub x20, x6, 120
    add x21, x7, 18
    mov x22, 800
    movz x10, 0xD0, lsl 16
    movk x10, 0xD0D0, lsl 00
    bl _circle

    //FONDO 
    movz x10, 0x4B, lsl 16
    movk x10, 0x2700, lsl 00
    b draw_pixel   

panel3:
    //Bola de Cañon 
    mov x20, x25
    mov x21, x26
    mov x22, 150
    movz x10, 0x20, lsl 16
    movk x10, 0x2020, lsl 00
    bl _circle

    //Pasto (rectangulo)
    mov x20, 200
    mov x21, 480
    mov x22, 0
    mov x23, 0
    movz x10, 0x33, lsl 16
    movk x10, 0x6600, lsl 00
    bl _rectangle

    //FONDO 
    movz x10, 0x4B, lsl 16
    movk x10, 0x2700, lsl 00
    b draw_pixel  

panel4:
    //Bola de Cañon 
    mov x20, x25
    mov x21, x26
    mov x22, 150
    movz x10, 0x20, lsl 16
    movk x10, 0x2020, lsl 00
    bl _circle

    //Puerta (rectangulo)
    mov x20, 330
    mov x21, 190
    mov x22, 310
    mov x23, 160
    movz x10, 0x4B, lsl 16
    movk x10, 0x2700, lsl 00
    bl _rectangle
    
    //Castillo 1 (rectangulo)
    mov x20, 400
    mov x21, 230
    mov x22, 240
    mov x23, 160
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Castillo 2 (rectangulo)
    mov x20, 400
    mov x21, 240
    mov x22, 380
    mov x23, 229
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Castillo 3 (rectangulo)
    mov x20, 360
    mov x21, 240
    mov x22, 340
    mov x23, 229
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Castillo 4 (rectangulo)
    mov x20, 300
    mov x21, 240
    mov x22, 280
    mov x23, 229
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Castillo 5 (rectangulo)
    mov x20, 260
    mov x21, 240
    mov x22, 240
    mov x23, 229
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle


    //Torre (rectangulo)
    mov x20, 360
    mov x21, 300
    mov x22, 280
    mov x23, 229
    movz x10, 0x2F, lsl 16
    movk x10, 0x2F2F, lsl 00
    bl _rectangle

    //FONDO 
    movz x10, 0x33, lsl 16
    movk x10, 0x6600, lsl 00
    b draw_pixel   

panel5:
    //FONDO 
    movz x10, 0xFF, lsl 16
    movk x10, 0xFFFF, lsl 00
    b draw_pixel   

panel6:
    //Explosion (ciculo)
    add x20, x6, 350
    mov x21, 230
    mov x22, 2000
    movz x10, 0xFF, lsl 16
    movk x10, 0x6666, lsl 00
    bl _circle

    //Explosion (ciculo)
    add x20, x6, 305
    mov x21, 260
    mov x22, 1800
    movz x10, 0xFF, lsl 16
    movk x10, 0x3333, lsl 00
    bl _circle

    //Explosion (ciculo)
    add x20, x6, 290
    mov x21, 210
    mov x22, 2500
    movz x10, 0xFF, lsl 16
    movk x10, 0x0000, lsl 00
    bl _circle
    
    //Castillo 1 (rectangulo)
    add x20, x6, 400
    mov x21, 250
    add x22, x6, 240
    mov x23, 160
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Torre (rectangulo)
    add x20, x6, 360
    mov x21, 300
    add x22, x6, 280
    mov x23, 249
    movz x10, 0x2F, lsl 16
    movk x10, 0x2F2F, lsl 00
    bl _rectangle

    //Tierra (rectangulo)
    add x20, x6, 440
    mov x21, 200
    add x22, x6, 200
    mov x23, 130
    movz x10, 0x4B, lsl 16
    movk x10, 0x2700, lsl 00
    bl _rectangle

    //FONDO 
    movz x10, 0x33, lsl 16
    movk x10, 0x6600, lsl 00
    b draw_pixel   

panel7:
    //Castillo 1 (rectangulo)
    mov x20, 260
    mov x21, 250
    mov x22, 240
    mov x23, 160
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Castillo 2 (rectangulo)
    mov x20, 390
    mov x21, 230
    mov x22, 360
    mov x23, 160
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Castillo 3 (rectangulo)
    mov x20, 361
    mov x21, 210
    mov x22, 310
    mov x23, 160
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle
    
    //Castillo 4 (rectangulo)
    mov x20, 390
    mov x21, 190
    mov x22, 240
    mov x23, 160
    movz x10, 0x40, lsl 16
    movk x10, 0x4040, lsl 00
    bl _rectangle

    //Fuego (elipse)
    mov x20, 345    //coordenada x
    mov x21, 205 //coordenada y
    mov x22, 1      //horizontal
    mov x23, 2      //vertical
    add x24, x6, 100    //size
    movz x10, 0xFF, lsl 16
    movk x10, 0xFF33, lsl 00
    bl _elipse

    //Fuego (elipse)
    mov x20, 345    //coordenada x
    add x21, x6, 205 //coordenada y
    mov x22, 1      //horizontal
    mov x23, 2      //vertical
    mov x24, 250    //size
    movz x10, 0xFF, lsl 16
    movk x10, 0x3333, lsl 00
    bl _elipse

    //Tierra (rectangulo)
    mov x20, 440
    mov x21, 200
    mov x22, 200
    mov x23, 130
    movz x10, 0x4B, lsl 16
    movk x10, 0x2700, lsl 00
    bl _rectangle

    //FONDO 
    movz x10, 0x33, lsl 16
    movk x10, 0x6600, lsl 00
    b draw_pixel   




_circle:    //x^2+y^2<=r^2
    sub x3, x1, x20 // Posicion actual en X 
    mul x3, x3, x3  // x^2

    sub x4, x2, x21 // Posicion actual en Y
    mul x4, x4, x4  // y^2

    add x3, x3, x4  //x^2+y^2

    mov x4, x22
    sub x3, x3, x4  //Compara con r^2
    cmp x3, xzr      
    b.le draw_pixel // DIBUJA CIRCULO SI CUMPLE LA CONDICION
    ret             // SI NO CUMPLE, RETORNA PARA PROBAR OTRAS FORMAS

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
        
_r_circle: //Circulo invertido
    sub x3, x1, x20 
    mul x3, x3, x3
    sub x4, x2, x21
    mul x4, x4, x4
    add x3, x3, x4
    mov x4, x22
    sub x3, x3, x4
    cmp x3, xzr      
    b.ge draw_pixel  // Usa >= en vez de <=
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
    stur w10, [x0]    // Establecer el color del pixel
next_pixel:
    add x0, x0, 4       // Siguiente pixel
    sub x1, x1, 1       // Decrementar el contador de X
    cbnz x1, loop0      // Si no es el final de la fila, saltar
    sub x2, x2, 1       // Decrementar el contador de Y
    cbnz x2, loop1      // Si no es la última fila, saltar

    add x12, x12, 1     // Incrementa el frame

    cmp x11, xzr        // Evita teclas mientras esta la animacion
    b.eq animation
    cmp x12, #12        // Cooldown de espacio a partti de los frames
    b.le repeat
check_key:
    mov x9, GPIO_BASE
    ldr w15, [x9, GPIO_GPLEV0]  //agarra el registro 0x3F20001C

    // Compara 0x3F20001C con el valor de cada teclas
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

    b repeat

tecla_w:
    mov x12, 12     // Evita cooldown
    add x7, x7, 5   // Mueve + eje Y
    b repeat
tecla_a:
    mov x12, 12     // Evita cooldown 
    add x6, x6, 5   // Mueve + eje X
    b repeat
tecla_s:
    mov x12, 12     // Evita cooldown
    sub x7, x7, 5   // Mueve - eje Y
    b repeat
tecla_d:
    mov x12, 12     // Evita cooldown
    sub x6, x6, 5   // Mueve - eje X
    b repeat
tecla_espacio:
    mov x12, 0      // Reinicia cooldown
    add x5, x5, 1   // Tansicion de planos
    b repeat

animation: 
    cmp x5, 2
    b.eq ani_2

    cmp x5, 3
    b.eq ani_3

    cmp x5, 4
    b.eq ani_4

    cmp x5, 5
    b.eq ani_5

    cmp x5, 6
    b.eq ani_6

    cmp x5, 7
    b.eq ani_7

ani_2:  // Controla el timing del panel2
    cmp x12, 10
    b.eq next_ani
    b repeat

ani_3:  // Controla el timing del panel3
    sub x25, x25, 4
    cmp x25, xzr
    b.lt next_ani
    b repeat

ani_4:  // Controla el timing del panel4
    sub x25, x25, 8
    cmp x25, SCREEN_WIDTH/2
    b.lt next_ani
    b repeat

ani_5: // Controla el timing del panel5
    cmp x12, 10
    b.eq next_ani

ani_6:  // Controla el timing del panel6
    cmp x12, 25
    b.eq next_ani
    cmp x7, xzr
    b.eq shake_rgt
    shake_lft:
        mov x7, 0
        mov x6, -4
        b repeat
    shake_rgt:
        mov x7, 1
        mov x6, 4
        b repeat

ani_7:  // Controla el timing del panel7
    cmp x7, xzr
    b.eq shake_up
    shake_dwn:
        mov x7, 0
        mov x6, -5
        b repeat
    shake_up:
        mov x7, 1
        mov x6, 5
        b repeat

next_ani:
    mov x6, 0     // Reutilizo para animacion
    mov x7, xzr     // Reutilizo para animacion
    mov x25, SCREEN_WIDTH
    mov x12, 0      // Reinicia conteo de frames
    add x5, x5, 1   // Tansicion de planos
    b repeat


InfLoop:
    b InfLoop
