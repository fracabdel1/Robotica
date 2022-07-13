MODULE Module1
    CONST robtarget pBaseOrigen:=[[1500,-500,750],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pCentroDestino:=[[1700,1000,750],[0,0,1,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget pReposo:=[[1808.910161514,0,1855],[0.5,0,0.866025404,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    !Constantes creadas por mi
    CONST num altura := 50;
    
    PROC main()
        Ejercicio2 10, 3, 200;
    ENDPROC
    
    PROC Ejercicio2 (num nPiezasTorreOrigen, num nTorresDestino, num radioCircunferencia)
        VAR robtarget tabPos{21};
        VAR robtarget pAproxCirculo;
        VAR robtarget pAproxOrigen;
        VAR robtarget pApoyo;
        VAR robtarget pAux;
        VAR robtarget pBase;
        VAR num gradosIncremt := 0;
        VAR num gradosGirados := 0;
        VAR num nPiezasEnTorre := 0;
        VAR num rotacion := 0;
        VAR num alturaTorreDestino := 0;
        VAR num angX;
        VAR num angY;
        VAR num angZ;
        
        !Vamos a crear un punto de aproximación encima del centro del circulo y 5 piezas por encima de la torre origen
        pAproxCirculo := Offs (pCentroDestino, 0, 0, altura * nPiezasTorreOrigen);
        pAproxOrigen := Offs (pBaseOrigen, 0, 0, (nPiezasTorreOrigen * altura) + (altura * 5));
        
        !Creamos el punto inicial de la torre origen
        pBase := Offs (pBaseOrigen, 0, 0, altura * nPiezasTorreOrigen);
        
        !Como el círculo tiene 360 grados, podemos descomponen los grados en tantas partes como puntos tenemos
        gradosIncremt := 360 / nTorresDestino;
        alturaTorreDestino := altura;
        
        !Hacemos un bucle para recorrer todas las piezas y asignarles una posición
        FOR i FROM 1 TO nPiezasTorreOrigen + 1 DO
            
                !Sacamos el cuaternio de EulerZXY()
                angZ := EulerZYX(\Z, pCentroDestino.rot);
                angY := EulerZYX(\Y, pCentroDestino.rot);
                angX := EulerZYX(\X, pCentroDestino.rot);
                
                !Creamos y rotamos el pinto inicial
                pAux := pCentroDestino;
                pAux.rot := OrientZYX(angZ + gradosGirados, angY, angX);
                
                !Creamos otro punto 
                pApoyo := Offs (pAux, 0, radioCircunferencia, alturaTorreDestino);
                    
                !Añadimos el punto en el array
                tabPos{i} := pApoyo;
                
                !Incrementamos el numero de piezas puestas
                nPiezasEnTorre := nPiezasEnTorre + 1;
                
                !Si se han recorrido todas las torres aumentamos la altura
                IF nPiezasEnTorre = nTorresDestino THEN
                    alturaTorreDestino := alturaTorreDestino + altura;
                    nPiezasEnTorre := 0;
                ENDIF
                
                !Rotamos la pieza en el eje Z 
                gradosGirados := gradosGirados + gradosIncremt;
                
               
        ENDFOR
        
        !En este segundo bucle for recorremos todos los puntos del array cogiendo y dejando las piezas
        FOR A FROM 1 TO nPiezasTorreOrigen DO
            
            !Movemos al punto de aproximación de la Torre Origen
            MoveL pAproxOrigen, v2000, fine, Ventosa\WObj:=wobj0;
            
            !Cogemos la pieza de la Torre Origen
            MoveLDO pBase, v2000, fine, Ventosa\WObj:=wobj0, SD_ActivaVentosa, 1;
            WaitDI ED_PiezaCogida, 1;
            MoveL pAproxOrigen, v2000, fine, Ventosa\WObj:=wobj0;
            
            !Movemos al punto de aproximacion del centro del círculo;
            MoveL pAproxCirculo, v2000, fine, Ventosa\WObj:=wobj0;
            
            !Depositamos la pieza en su sitio
            MoveLDO tabPos{A}, v2000, fine, Ventosa\WObj:=wobj0, SD_ActivaVentosa, 0;
            WaitDI ED_PiezaCogida, 0;
            MoveL pAproxCirculo, v2000, fine, Ventosa\WObj:=wobj0;
            
            !Bajamos la altura de la torre Base
            pBase := Offs (pBase, 0, 0, -altura);
            
        ENDFOR
        
    ENDPROC

ENDMODULE