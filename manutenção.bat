@echo off
:: ==============================================================================
:: SUPORTE TÉCNICO
:: AUTOR: RAFAEL WINTER
:: DESCRIÇÃO: SCRIPT DE SUPORTE TÉCNICO MULTIFUNCIONAL
:: ==============================================================================

:: ===== CONFIGURACAO VISUAL ============================================
:: Cor (Fundo=2 Verde, Texto=0 Preto)
title SUPORTE TECNICO
color 20

setlocal EnableDelayedExpansion

:: ===== LOG ============================================================
set "LOG=%~dp0suporte.log"

:: ==============================================================================
:: VERIFICAÇÃO DE PRIVILÉGIOS DE ADMINISTRADOR
:: Garante que o script seja executado com privilégios de administrador
:: ==============================================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo =============================================
    echo  ATENCAO: EXECUTE COMO ADMINISTRADOR
    echo =============================================
    pause
    exit /b
)

goto MENU_PRINCIPAL

:: ------ MENU PRINCIPAL -------------------------------------------
:MENU_PRINCIPAL
    cls
    call :CABECALHO

    echo ================= MENU PRINCIPAL =================
    echo.
    echo [1] Sistema
    echo [2] Rede
    echo [3] Seguranca
    echo [4] Manutencao
    echo [5] Ferramentas
    echo [R] Reiniciar Computador
    echo [H] Ajuda Geral
    echo [0] Sair
    echo.

    :: Validação da opção escolhida pelo usuário
    call :VALIDA_MENU OPCAO "0 1 2 3 4 5 R H" MENU_PRINCIPAL

    :: Redirecionamento para os submenus ou ações
    if "%OPCAO%"=="1" goto MENU_SISTEMA
    if "%OPCAO%"=="2" goto MENU_REDE
    if "%OPCAO%"=="3" goto MENU_SEGURANCA
    if "%OPCAO%"=="4" goto MENU_MANUTENCAO
    if "%OPCAO%"=="5" goto MENU_FERRAMENTAS
    if "%OPCAO%"=="6" goto MENU_USUARIOS
    if /I "%OPCAO%"=="R" goto RESTART_CONFIRM
    if /I "%OPCAO%"=="H" goto AJUDA_GERAL
    if "%OPCAO%"=="0" goto SAIR

goto MENU_PRINCIPAL
:: ==== FIM MENU PRINCIPAL ==========================================
::///////////////////////////////////////////////////////////////////////////////
:: ------ MENU 1 (SISTEMA) -----------------------------------------
:MENU_SISTEMA
    cls
    call :CABECALHO

    echo ============ SISTEMA ============
    echo.
    echo [1] Informacoes do Sistema
    echo [2] Informacoes de Hardware
    echo [3] Espaco em Disco
    echo [4] Diagnostico de Memoria
    echo [5] Reparar Arquivos do Sistema (SFC)
    echo [6] Criar Ponto de Restauracao
    echo [H] Ajuda
    echo [0] Voltar
    echo.

    :: Valida opção do usuário dentro do menu Sistema
    call :VALIDA_MENU OP_SIS "0 1 2 3 4 5 6 H" MENU_SISTEMA

    if /I "%OP_SIS%"=="H" goto AJUDA_SISTEMA
    if "%OP_SIS%"=="0" goto MENU_PRINCIPAL

    call :LOG "Sistema - Opcao %OP_SIS%"

    :: --------------------------------------------------------------------------
    ::     OPÇÃO 1 - INFORMAÇÕES DO SISTEMA
    :: --------------------------------------------------------------------------
    if "%OP_SIS%"=="1" (
        cls
        call :CABECALHO
        systeminfo
        pause
        goto MENU_SISTEMA
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 2 - INFORMAÇÕES DE HARDWARE
    :: --------------------------------------------------------------------------
    if "%OP_SIS%"=="2" (
        cls
        call :CABECALHO
        call :EXIBIR_HARDWARE
        pause
        goto MENU_SISTEMA
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 3 - ESPAÇO EM DISCO
    :: --------------------------------------------------------------------------
    if "%OP_SIS%"=="3" (
        cls
        call :CABECALHO
        powershell -Command "Get-Volume | Where-Object {$_.DriveLetter -ne $null} | Select DriveLetter, @{n='Livre(GB)';e={[math]::Round($_.SizeRemaining/1GB,2)}}, @{n='Total(GB)';e={[math]::Round($_.Size/1GB,2)}} | Format-Table -AutoSize"
        pause
        goto MENU_SISTEMA
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 4 - DIAGNÓSTICO DE MEMÓRIA
    :: --------------------------------------------------------------------------
    if "%OP_SIS%"=="4" (
        cls
        call :CABECALHO
        mdsched.exe
        pause
        goto MENU_SISTEMA
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 5 - REPARAR ARQUIVOS DO SISTEMA
    :: --------------------------------------------------------------------------
    if "%OP_SIS%"=="5" (
        cls
        call :CABECALHO
        sfc /scannow
        pause
        goto MENU_SISTEMA
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 6 - CRIAR PONTO DE RESTAURAÇÃO
    :: --------------------------------------------------------------------------
    if "%OP_SIS%"=="6" (
        cls
        call :CABECALHO
        powershell -Command "Checkpoint-Computer -Description 'Manual Restore' -RestorePointType MODIFY_SETTINGS"
        echo Ponto de restauracao criado.
        pause
        goto MENU_SISTEMA
    )
goto MENU_SISTEMA
:: ............. FUNCAO: EXIBIR_HARDWARE ..........................
:EXIBIR_HARDWARE
    echo --- Informacoes de Hardware:
    powershell -Command "Get-CimInstance Win32_Processor | Format-List Name,NumberOfCores,MaxClockSpeed"
    echo --- Informacoes Memoria RAM:
    powershell -Command "Get-CimInstance Win32_PhysicalMemory | Format-List BankLabel,Capacity,Speed"
    echo --- Informacoes de Discos:
    powershell -Command "Get-CimInstance Win32_DiskDrive | Format-List Model,Size,MediaType"
    echo --- Informacoes adaptadores:
    powershell -Command "Get-CimInstance Win32_VideoController | Format-List Name,AdapterRAM"
    echo --- Placa Mae:
    powershell -Command "Get-CimInstance Win32_BaseBoard | Format-List Manufacturer,Product,Version"
    echo.
goto :eof
:: ............. FIM FUNCAO: EXIBIR_HARDWARE ........................
:: ==== FIM MENU 1 (SISTEMA) =======================================
::///////////////////////////////////////////////////////////////////////////////
:: ------ MENU 2 (REDE) --------------------------------------------
:MENU_REDE
    cls
    call :CABECALHO
    echo ============ REDE ============
    echo.
    echo [1] Teste Ping Internet
    echo [2] IPConfig
    echo [3] IPConfig /All
    echo [4] Tracert
    echo [5] Netstat
    echo [6] Flush DNS
    echo [7] Reset Completo de Rede
    echo [8] Redes Wi-Fi
    echo [9] Teste de Velocidade
    echo [10] Meu IP
    echo [11] Ping Manual
    echo [12] Comparilhamento de Arquivos em Rede
    echo [13] Adaptadores de Rede
    echo [14] LOG de Redes (3 ultimos dias)
    echo [H] Ajuda
    echo [0] Voltar
    echo.

    :: Validação da opção do usuário dentro do menu Rede
    call :VALIDA_MENU OP_REDE "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 H" MENU_REDE

    if /I "%OP_REDE%"=="H" goto AJUDA_REDE
    if "%OP_REDE%"=="0" goto MENU_PRINCIPAL
    call :LOG "Rede - Opcao %OP_REDE%"

    :: --------------------------------------------------------------------------
    ::     OPÇÃO 1 - TESTE PING INTERNET
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="1" (
        cls
        call :CABECALHO
        echo ------------ Teste de Ping para google.com ------------
        ping google.com
        echo.
        echo ------------ Teste de Ping para assus.com ------------
        ping assus.com
        echo.
        echo ------------ Teste de Ping para cloudflare.com ------------
        ping cloudflare.com
        echo.
        echo ------------ Teste de Ping rede local ------------
        ping 192.168.2.254
        echo --------------------------------------------------
        ping 192.168.3.254
        echo --------------------------------------------------
        ping 192.168.4.254
        echo -------------------------------------------------- 
        ping 192.168.5.254
        echo.
        pause
        goto MENU_REDE
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 2 - EXIBIR CONFIGURAÇÃO IP SIMPLES
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="2" (
        cls
        call :CABECALHO
        ipconfig
        pause
        goto MENU_REDE
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 3 - EXIBIR CONFIGURAÇÃO IP COMPLETA
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="3" (
        cls
        call :CABECALHO
        ipconfig /all
        pause
        goto MENU_REDE
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 4 - TRACERT PARA ENDEREÇO DEFINIDO
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="4" (
        cls
        call :CABECALHO
        set /p TARGET=Endereco: 
        if "!TARGET!"=="" (
            echo Endereco invalido ou vazio.
            pause
            goto MENU_REDE
        )
        tracert "!TARGET!"
        pause
        goto MENU_REDE
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 5 - NETSTAT
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="5" (
        cls
        call :CABECALHO
        netstat -ano
        pause
        goto MENU_REDE
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 6 - FLUSH DNS
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="6" (
        cls
        call :CABECALHO
        ipconfig /flushdns
        pause
        goto MENU_REDE
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 7 - RESET COMPLETO DE REDE
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="7" (
        cls
        call :CABECALHO
        goto REDE_RESET_EXEC
        echo.
        pause
        goto MENU_REDE
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 8 - EXIBIR REDES WI-FI DISPONÍVEIS
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="8" (
        cls
        call :CABECALHO
        netsh wlan show networks
        pause
        goto MENU_REDE
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 9 - TESTE DE VELOCIDADE ONLINE
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="9" (
        cls
        call :CABECALHO
        start https://www.speedtest.net/pt
        pause
        goto MENU_REDE
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 10 - ABRIR SITE PARA VER MEU IP
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="10" (
        cls
        call :CABECALHO
        start https://meuip.org/
        pause
        goto MENU_REDE
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 11 - PING MANUAL
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="11" (
        cls
        call :CABECALHO
        goto MENU_PING_MANUAL
        pause
        goto MENU_REDE
    )
    :: --------------------------------------------------------------------------
    ::     OPÇÃO 12 - COMPARILHAMENTO DE ARQUIVOS EM REDE
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="12" (
        cls
        call :CABECALHO
        start fsmgmt.msc
        pause
        goto MENU_REDE
    )

    :: --------------------------------------------------------------------------
    ::     OPÇÃO 13 - ADAPTADORES DE REDE
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="13" (
        cls
        call :CABECALHO
        ncpa.cpl
        pause
        goto MENU_REDE
    )

    :: --------------------------------------------------------------------------
    ::     OPÇÃO 14 - LOG DE REDES (3 ÚLTIMOS DIAS)
    :: --------------------------------------------------------------------------
    if "%OP_REDE%"=="14" (
        cls
        call :CABECALHO
        netsh wlan show wlanreport
        pause
        goto MENU_REDE
    )
    pause
    goto MENU_REDE

:: ............. FUNCAO: REDE_RESET_EXEC .............................
:REDE_RESET_EXEC
    echo ATENCAO: Isto vai reiniciar a pilha TCP/IP e Winsock e pode cortar a conexao.
    call :READ_YN "Confirma reset completo de rede (S/N)?" CONFIRM
    if /I "%CONFIRM%"=="S" (
        call :LOG "Rede" "Reset iniciado"
        ipconfig /release
        ipconfig /flushdns
        netsh winsock reset
        netsh int ip reset
        ipconfig /renew
        call :LOG "Rede" "Reset concluido"
        echo Reset concluido. Pode ser necessario reiniciar o PC.
    ) else (
        call :LOG "Rede" "Reset cancelado"
        echo Cancelado.
    )
    pause
    goto MENU_REDE
:: ............. FIM FUNCAO: REDE_RESET_EXEC .........................
:: ............. FUNCAO: MENU_PING_MANUAL ..............................
:MENU_PING_MANUAL
    echo ------- Ping Manual -------
    set /p HOST=Host/IP: 
    if "%HOST%"=="" (echo Valor invalido.&pause&goto MENU_REDE)
    set /p COUNT=Contagem (padrao 4): 
    if "%COUNT%"=="" set COUNT=4
    set /p SIZE=Tamanho buffer (bytes, opcional): 
    if "%SIZE%"=="" (
        ping -n %COUNT% "%HOST%"
    ) else (
        ping -n %COUNT% -l %SIZE% "%HOST%"
    )
    call :LOG "Rede" "Ping manual para %HOST% (%COUNT%x, size=%SIZE%)"
    pause
    goto MENU_REDE
:: ............. FIM FUNCAO: MENU_PING_MANUAL ..........................
:: ==== FIM MENU 2 (REDE) ==========================================
::///////////////////////////////////////////////////////////////////////////////
:: ------ MENU 3 (SEGURANCA) --------------------------------------
:MENU_SEGURANCA
    cls
    call :CABECALHO

    echo ============ SEGURANCA ============
    echo.
    echo [1] Ativar Firewall
    echo [2] Desativar Firewall
    echo [3] Status do Windows Defender
    echo [4] Varredura Rapida do Defender
    echo [5] Varredura Completa do Defender
    echo [6] Verificar BitLocker
    echo [7] Desativar SMB1
    echo [8] Verificar Atualizacoes de Seguranca
    echo [9] Desabilita UAC
    echo [H] Ajuda deste menu
    echo [0] Voltar
    echo.

    call :VALIDA_MENU OP_SEG "0 1 2 3 4 5 6 7 8 9 H" MENU_SEGURANCA

    if /I "%OP_SEG%"=="H" goto AJUDA_SEGURANCA
    if "%OP_SEG%"=="0" goto MENU_PRINCIPAL

    call :LOG "Seguranca - Opcao %OP_SEG%"

    :: --------------------------------------------------------------------------
    ::     [1] ATIVAR FIREWALL
    :: --------------------------------------------------------------------------
    if "%OP_SEG%"=="1" (
        cls
        call :CABECALHO
        echo Ativando Firewall do Windows...
        netsh advfirewall set allprofiles state on
        call :LOG "Firewall ativado"
        echo ............................................
        netsh advfirewall show allprofiles
        echo ............................................
        echo Firewall ativado.
        echo.
        pause
        goto MENU_SEGURANCA
    )

    :: --------------------------------------------------------------------------
    ::     [2] DESATIVAR FIREWALL
    :: --------------------------------------------------------------------------
    if "%OP_SEG%"=="2" (
        cls
        call :CABECALHO
        call :READ_YN "Confirme desativar Firewall S/N:" CONFIRM
        echo Desativando Firewall do Windows...
        echo ............................................
        if /I "%CONFIRM%"=="S" (
            netsh advfirewall set allprofiles state off
            call :LOG "Firewall desativado"
        )
        netsh advfirewall show allprofiles
        echo ............................................
        echo Firewall desativado.
        echo.
        pause
        goto MENU_SEGURANCA
    )

    :: --------------------------------------------------------------------------
    :: [3] STATUS DO WINDOWS DEFENDER (COM RESULTADO FINAL)
    :: --------------------------------------------------------------------------
    if "%OP_SEG%"=="3" (
        cls
        call :CABECALHO

        powershell -NoProfile -Command "Get-MpComputerStatus | Format-List"

        echo.
        call :DEFENDER_ATIVO
        if errorlevel 1 (
            echo RESULTADO FINAL: DEFENDER DESATIVADO OU PASSIVO
            call :LOG "Defender inativo/passivo"
        ) else (
            echo RESULTADO FINAL: DEFENDER ATIVO
            call :LOG "Defender ativo"
        )

        pause
        goto MENU_SEGURANCA
    )

    :: --------------------------------------------------------------------------
    :: [4] VARREDURA RAPIDA DO DEFENDER
    :: --------------------------------------------------------------------------
    if "%OP_SEG%"=="4" (
        cls
        call :CABECALHO

        call :DEFENDER_ATIVO
        if errorlevel 1 (
            echo Windows Defender nao esta ativo.
            echo Varredura rapida nao pode ser executada.
            pause
            goto MENU_SEGURANCA
        )

        echo Iniciando varredura rapida do Windows Defender...
        powershell -NoProfile -Command "Start-MpScan -ScanType QuickScan"

        if errorlevel 1 (
            echo Erro ao iniciar a varredura rapida.
        )

        pause
        goto MENU_SEGURANCA
    )

    :: --------------------------------------------------------------------------
    :: [5] VARREDURA COMPLETA DO DEFENDER
    :: --------------------------------------------------------------------------
    if "%OP_SEG%"=="5" (
        cls
        call :CABECALHO

        call :DEFENDER_ATIVO
        if errorlevel 1 (
            echo Windows Defender nao esta ativo.
            echo Varredura completa nao pode ser executada.
            pause
            goto MENU_SEGURANCA
        )

        call :READ_YN "Confirme varredura completa S/N:" CONFIRM
        if /I "%CONFIRM%"=="S" (
            echo Iniciando varredura completa. Pode demorar bastante...
            "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
        )

        pause
        goto MENU_SEGURANCA
    )

    :: --------------------------------------------------------------------------
    :: [6] STATUS DO BITLOCKER
    :: --------------------------------------------------------------------------
    if "%OP_SEG%"=="6" (
        cls
        call :CABECALHO
        manage-bde -status
        pause
        goto MENU_SEGURANCA
    )

    :: --------------------------------------------------------------------------
    :: [7] DESATIVAR SMB1
    :: --------------------------------------------------------------------------
    if "%OP_SEG%"=="7" (
        cls
        call :CABECALHO
        call :READ_YN "Confirme desativar SMB1 S/N:" CONFIRM
        if /I "%CONFIRM%"=="S" (
            dism /online /norestart /disable-feature /featurename:SMB1Protocol
            call :LOG "SMB1 desativado"
            echo Reinicializacao pode ser necessaria.
        )
        sc query mrxsmb10
        pause
        goto MENU_SEGURANCA
    )

    :: --------------------------------------------------------------------------
    ::     [8] VERIFICAR ATUALIZACOES DE SEGURANCA
    :: --------------------------------------------------------------------------
    if "%OP_SEG%"=="8" (
        cls
        call :CABECALHO
        echo Buscando atualizacoes de seguranca...
        echo.
        systeminfo | findstr /I "hotfix"
        if errorlevel 1 (
            echo.
            echo Alternativa: Consultando registry do Windows Update...
            echo.
            reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /s | findstr /I "security"
        )
        call :LOG "Seguranca - Opcao 8 - Atualizacoes de seguranca verificadas"
        echo.
        pause
        goto MENU_SEGURANCA
    )

    :: --------------------------------------------------------------------------
    ::     [9] DESABILITA UAC
    :: --------------------------------------------------------------------------
    if "%OP_SEG%"=="9" (
        cls
        call :CABECALHO
        call :READ_YN "Confirme desabilitar UAC S/N:" CONFIRM
        if /I "%CONFIRM%"=="S" (
            reg.exe ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f
            call :LOG "UAC desabilitado"
            echo UAC desabilitado. Reinicializacao necessaria para aplicar.
        )
        reg.exe QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA
        pause
        goto MENU_SEGURANCA
    )

    goto MENU_SEGURANCA
:: ............. FUNCAO: DEFENDER_ATIVO ..................................
:DEFENDER_ATIVO
    powershell -NoProfile -Command ^
    "$s = Get-MpComputerStatus; " ^
    "if ($s.AMServiceEnabled -and $s.AntivirusEnabled) { exit 0 } else { exit 1 }"
    exit /b %ERRORLEVEL%
:: ............. FIM FUNCAO: DEFENDER_ATIVO ..............................
:: ==== FIM MENU 3 (SEGURANCA) ====================================
::///////////////////////////////////////////////////////////////////////////////
:: ------ MENU 4 (MANUTENCAO) -------------------------------------
:MENU_MANUTENCAO
    cls
    call :CABECALHO

    echo =========== MANUTENCAO ===========
    echo.
    echo [1] Limpar Arquivos Temporarios
    echo [2] Limpeza de Disco Avancada
    echo [3] Otimizar Disco (HDD/SSD)
    echo [4] Verificar Erros do Sistema
    echo [5] Windows Update
    echo [6] Visualizar Log de Suporte
    echo [7] Reiniciar Windows Explorer
    echo [8] Forcar updates
    echo [H] Ajuda deste menu
    echo [0] Voltar
    echo.

    call :VALIDA_MENU OP_MAN "0 1 2 3 4 5 6 7 8 H" MENU_MANUTENCAO

    if /I "%OP_MAN%"=="H" goto AJUDA_MANUTENCAO
    if "%OP_MAN%"=="0" goto MENU_PRINCIPAL

    call :LOG "Manutencao - Opcao %OP_MAN%"

    :: --------------------------------------------------------------------------
    ::     [1] LIMPAR ARQUIVOS TEMPORARIOS
    :: --------------------------------------------------------------------------
    if "%OP_MAN%"=="1" (
        cls
        call :CABECALHO
        goto LIMPAR_TEMP
    )

    :: --------------------------------------------------------------------------
    ::     [2] LIMPEZA DE DISCO AVANCADA
    :: --------------------------------------------------------------------------
    if "%OP_MAN%"=="2" (
        cls
        call :CABECALHO
        echo Iniciando...
        cleanmgr /sageset:1
        echo Configuracao salva. Agora executando a limpeza...
        cleanmgr /sagerun:1
        echo Limpeza concluida.
        echo.
        pause
        goto MENU_MANUTENCAO
    )

    :: --------------------------------------------------------------------------
    ::     [3] OTIMIZAR DISCO (HDD/SSD)
    :: --------------------------------------------------------------------------
    if "%OP_MAN%"=="3" (
        cls
        call :CABECALHO
        echo Analisando o volume do sistema...
        defrag %SystemDrive% /A /V
        echo.
        call :READ_YN "Se a analise indicar necessidade, executar a otimizacao? [S/N]:" CONFIRM 
        if /I "%CONFIRM%"=="S" (
            echo Otimizando o volume do sistema...       
            defrag %SystemDrive% /O /V
            echo.
            echo Otimizacao concluida.
        ) else (
            echo Otimizacao cancelada pelo usuario.
        )
        pause
        goto MENU_MANUTENCAO
    )

    :: --------------------------------------------------------------------------
    ::     [4] VERIFICAR ERROS DO SISTEMA (CHDSK)
    :: --------------------------------------------------------------------------
    if "%OP_MAN%"=="4" (
        cls
        call :CABECALHO
        chkdsk C:
        pause
        goto MENU_MANUTENCAO
    )

    :: --------------------------------------------------------------------------
    ::     [5] WINDOWS UPDATE (AJUSTES)
    :: --------------------------------------------------------------------------
    if "%OP_MAN%"=="5" (
        cls
        call :CABECALHO
        start ms-settings:windowsupdate
        pause
        goto MENU_MANUTENCAO
    )

    :: --------------------------------------------------------------------------
    ::     [6] VISUALIZAR LOG DE SUPORTE
    :: --------------------------------------------------------------------------
    if "%OP_MAN%"=="6" (
        cls
        call :CABECALHO
        type "%LOG%"
        pause
        goto MENU_MANUTENCAO
    )

    :: --------------------------------------------------------------------------
    ::     [7] REINICIAR WINDOWS EXPLORER
    :: --------------------------------------------------------------------------
    if "%OP_MAN%"=="7" (
        cls
        call :CABECALHO
        echo Reiniciando Windows Explorer...
        taskkill /f /im explorer.exe >nul 2>&1
        start explorer.exe
        echo Explorer reiniciado.
        call :LOG "Explorer reiniciado"
        pause
        goto MENU_MANUTENCAO
    )

    :: --------------------------------------------------------------------------
    ::     [8] FORCAR UPDATES
    :: --------------------------------------------------------------------------
    if "%OP_MAN%"=="8" (
        cls
        call :CABECALHO
        echo Forcando atualizacoes...
        gpupdate /force
        echo.
        pause
        goto MENU_MANUTENCAO
    )
:: ............. FUNÇÃO: MENU 4.1 LIMPAR_TEMP ......................
:LIMPAR_TEMP
    setlocal DisableExtensions & setlocal EnableExtensions & setlocal DisableDelayedExpansion
    echo.
    echo ================= LIMPEZA SIMPLES =================
    echo Limpando temporarios e caches basicos do Windows...
    echo ===================================================
    echo.
    echo ================= 1 %%TEMP%% do usuario =================
    if exist "%TEMP%\" (
        del /s /q /f "%TEMP%\*.*" 2>nul
        for /d %%D in ("%TEMP%\*") do rd /s /q "%%~fD" 2>nul
        echo - TEMP do usuario limpo.
    ) else echo - TEMP do usuario nao encontrado (ok).

    echo.
    echo ================= 2 C:\Windows\Temp =================
    if exist "C:\Windows\Temp\" (
        del /s /q /f "C:\Windows\Temp\*.*" 2>nul
        for /d %%D in ("C:\Windows\Temp\*") do rd /s /q "%%~fD" 2>nul
        echo - Windows\Temp limpo.
    ) else echo - Windows\Temp nao encontrado.

    echo.
    echo ================= 3 C:\Windows\Prefetch =================
    if exist "C:\Windows\Prefetch\" (
        del /q /f "C:\Windows\Prefetch\*.*" 2>nul
        echo - Prefetch limpo.
    ) else echo - Prefetch nao encontrado.

    echo.
    echo ================= 4 C:\Windows\SoftwareDistribution\Download =================
    if exist "C:\Windows\SoftwareDistribution\Download\" (
        del /s /q /f "C:\Windows\SoftwareDistribution\Download\*.*" 2>nul
        for /d %%D in ("C:\Windows\SoftwareDistribution\Download\*") do rd /s /q "%%~fD" 2>nul
        echo - SoftwareDistribution\Download limpo.
    ) else echo - Cache do Windows Update nao encontrado.

    echo.
    echo ================= 5 C:\ProgramData\Microsoft\Windows\DeliveryOptimization\Cache =================
    if exist "C:\ProgramData\Microsoft\Windows\DeliveryOptimization\Cache\" (
        del /s /q /f "C:\ProgramData\Microsoft\Windows\DeliveryOptimization\Cache\*.*" 2>nul
        for /d %%D in ("C:\ProgramData\Microsoft\Windows\DeliveryOptimization\Cache\*") do rd /s /q "%%~fD" 2>nul
        echo - Delivery Optimization limpo.
    ) else echo - Delivery Optimization nao encontrado.

    echo.
    echo ===================================================
    echo ================= Concluido =======================
    echo ===================================================
    pause
    goto MENU_MANUTENCAO
:: ............. FIM FUNCAO: LIMPAR_TEMP .............................
:: ==== FIM MENU 4 (MANUTENCAO) ===================================
::///////////////////////////////////////////////////////////////////////////////
:: ------ MENU 5 (FERRAMENTAS) ------------------------------------
:MENU_FERRAMENTAS
    cls
    call :CABECALHO
    echo =========== FERRAMENTAS =========== 
    echo.
    echo [1] Gerenciador de Tarefas
    echo [2] Gerenciador de Dispositivos
    echo [3] Editor do Registro
    echo [4] PowerShell
    echo [5] Servicos do Windows
    echo [6] Visualizador de Eventos
    echo [7] Visualizador MSCONFIG
    echo [8] Visualizador de Eventos Grafico
    echo [9] painel de Controle
    echo [10] Impressoras e Dispositivos 
    echo [11] Desisntalar Programas
    echo [12] Politicas de Grupos 
    echo [13] Propriendades do Sistema
    echo [14] Contas de Usuario
    echo [H] Ajuda
    echo [0] Voltar
    echo.

    call :VALIDA_MENU OP_FER "0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 H" MENU_FERRAMENTAS
    if /I "%OP_FER%"=="H" goto AJUDA_FERRAMENTAS
    if "%OP_FER%"=="0" goto MENU_PRINCIPAL

    :: --------------------------------------------------------------------------
    ::     [1] GERENCIADOR DE TAREFAS
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="1" (
        cls
        call :CABECALHO
        start taskmgr
        goto MENU_FERRAMENTAS
    ) 

    :: --------------------------------------------------------------------------
    ::     [2] GERENCIADOR DE DISPOSITIVOS
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="2" (
        cls
        call :CABECALHO
        start devmgmt.msc
        goto MENU_FERRAMENTAS
    )

    :: --------------------------------------------------------------------------
    ::     [3] EDITOR DO REGISTRO
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="3" (
        cls
        call :CABECALHO
        start regedit
        goto MENU_FERRAMENTAS
    )

    :: --------------------------------------------------------------------------
    ::     [4] POWERSHELL (CONSOLE)
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="4" (
        cls
        call :CABECALHO
        start powershell
        goto MENU_FERRAMENTAS
    )

    :: --------------------------------------------------------------------------
    ::     [5] SERVIÇOS DO WINDOWS
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="5" (
        cls
        call :CABECALHO
        start services.msc
        goto MENU_FERRAMENTAS
    )

    :: --------------------------------------------------------------------------
    ::     [6] VISUALIZADOR DE EVENTOS
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="6" (
        cls
        call :CABECALHO
        start eventvwr.msc
        goto MENU_FERRAMENTAS
    )
    
    :: --------------------------------------------------------------------------
    ::     [7] MSCONFIG (INFORMAÇÕES DE INICIALIZAÇÃO)
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="7" (
        cls
        call :CABECALHO
        start msconfig
        goto MENU_FERRAMENTAS
    )

    :: --------------------------------------------------------------------------
    ::     [8] VISUALIZADOR DE EVENTOS GRÁFICO
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="8" (
        cls
        call :CABECALHO
        start perfmon /rel
        goto MENU_FERRAMENTAS
    )

    :: --------------------------------------------------------------------------
    ::     [9] PAINEL DE CONTROLE
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="9" (
        cls
        call :CABECALHO
        start control
        goto MENU_FERRAMENTAS
    )

    :: --------------------------------------------------------------------------
    ::     [10] IMPRESSORAS E DISPOSITIVOS      
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="10" (
        cls
        call :CABECALHO
        start ms-settings:printers
        goto MENU_FERRAMENTAS
    )

    :: --------------------------------------------------------------------------
    ::     [11] DESINSTALAR PROGRAMAS
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="11" (
        cls
        call :CABECALHO
        start appwiz.cpl
        goto MENU_FERRAMENTAS
    )

    :: --------------------------------------------------------------------------
    ::     [12] POLITICAS DE GRUPOS
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="12" (
        cls
        call :CABECALHO
        start gpedit.msc
        goto MENU_FERRAMENTAS
    )

    :: --------------------------------------------------------------------------
    ::     [13] PROPRIEDADES DO SISTEMA
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="13" (
        cls
        call :CABECALHO
        start sysdm.cpl
        goto MENU_FERRAMENTAS
    )

    :: --------------------------------------------------------------------------
    ::     [14] CONTAS DE USUARIO
    :: --------------------------------------------------------------------------
    if "%OP_FER%"=="14" (
        cls
        call :CABECALHO
        start netplwiz
        goto MENU_FERRAMENTAS
    )

    pause & goto MENU_FERRAMENTAS
:: ==== FIM MENU 5 (FERRAMENTAS) ==================================
::///////////////////////////////////////////////////////////////////////////////
:: ====== FUNÇÕES AUXILIARES ============================================
:: ............. FUNCAO: LOG ............................................
:LOG
    rem Aceita multiplos argumentos e registra mensagem completa
    echo [%date% %time%] %* >> "%LOG%" 2>nul
    goto :eof
:: ............. FIM FUNCAO: LOG ........................................

:: ............. FUNCAO: VALIDA_MENU ....................................
:VALIDA_MENU
    setlocal EnableDelayedExpansion
    
:VALIDA_MENU_LOOP
    set /p "%1=Escolha uma opcao: "
    set "INPUT=!%1!"
    set "INPUT=!INPUT: =!"
    set "%1=!INPUT!"
    
    if "!%1!"=="" (
        echo Opcao vazia!
        goto VALIDA_MENU_LOOP
    )
    set "VALIDA=0"
    for %%A in (%~2) do if /I "!%1!"=="%%A" set "VALIDA=1"

    if "!VALIDA!"=="0" (
        echo Opcao invalida! Opcoes: %~2
        goto VALIDA_MENU_LOOP
    )
    
    endlocal & set "%1=%INPUT%"
    goto :eof
:: ............. FIM FUNCAO: VALIDA_MENU ................................
:: ............. FUNCAO: CABECALHO ......................................
:CABECALHO
    echo =============================================
    echo     SUPORTE TECNICO PROFISSIONAL
    echo         POR: RAFAEL WINTER
    echo  Usuario: %USERNAME%       PC: %COMPUTERNAME%
    echo  Data: %DATE%             Hora: %TIME%
    echo =============================================
    echo.
    goto :eof
:: ............. FIM FUNCAO: CABECALHO ..................................

:: ............. FUNCAO: LER S/N ........................................
:READ_YN
    rem Uso: call :READ_YN "Mensagem S/N:" VAR
    setlocal EnableDelayedExpansion
:READ_YN_LOOP
    set /p REPLY=%~1
    if "!REPLY!"=="" (
        echo Informe S ou N.
        goto READ_YN_LOOP
    )
    set "FIRST=!REPLY:~0,1!"
    if /I "!FIRST!"=="S" (
        endlocal & set "%~2=S"
        goto :eof
    )
    if /I "!FIRST!"=="N" (
        endlocal & set "%~2=N"
        goto :eof
    )
    echo Opcao invalida. Digite S ou N.
    goto READ_YN_LOOP
:: ............. FIM FUNCAO: LER S/N ........................................

:: ............. FUNCAO: SAIR / REINICIAR ........................................
:RESTART_CONFIRM
    cls
    call :READ_YN "Deseja reiniciar o computador agora? S/N:" CONFIRM
    if "%CONFIRM%"=="S" (
        cls
        echo Reiniciando o computador em 5 segundos... Pressione C para cancelar.
        set "RESTART_CANCEL=0"
        for /L %%I in (5,-1,1) do (
            echo Reiniciando em %%I...
            choice /n /c CW /t 1 /d W >nul
            rem se C (primeira opcao) foi pressionado, errorlevel == 1
            if errorlevel 1 if not errorlevel 2 (
                set "RESTART_CANCEL=1"
                goto RESTART_END
            )
        )
        goto RESTART_END
    )
    goto MENU_PRINCIPAL

:SAIR
    cls
    call :CABECALHO
    echo Encerrando Suporte Tecnico...
    timeout /t 2 >nul
    exit /b 0

:RESTART_END
    if "!RESTART_CANCEL!"=="1" (
        echo Reinicio cancelado.
        pause
    ) else (
        shutdown /r /t 0
    )
    goto MENU_PRINCIPAL
:: ............. FIM FUNCAO: SAIR / REINICIAR ........................................
::////////////////////////////////////////////////////////////////////////////////
:: ------ AJUDA - GERAL -------------------------------------------- 
:AJUDA_GERAL
    cls
    call :CABECALHO
    echo AJUDA GERAL
    echo.
    echo Uso: entre nas opcoes dos menus e pressione 'H' para ajuda especifica.
    echo Principais areas:
    echo  - Sistema      : Informacoes, memoria, SFC, ponto de restauracao
    echo  - Rede         : Ping, IPConfig, tracert, reset de rede, ping manual
    echo  - Seguranca    : Firewall, Windows Defender, BitLocker, SMB1
    echo  - Manutencao   : Limpeza, checagem de disco, Windows Update, logs
    echo  - Otimizacao   : Remocao de bloatware, telemetria, animacoes
    echo  - Ferramentas  : Acessos rapido a ferramentas do Windows
    echo.
    echo Para ajuda especifica use H em qualquer menu ou escolha o menu e pressione H.
    pause
    goto MENU_PRINCIPAL
:: ==== FIM AJUDA - GERAL ==========================================
::///////////////////////////////////////////////////////////////////////////////
:: ------ AJUDA - SISTEMA -----------------------------------------
:AJUDA_SISTEMA
    cls
    call :CABECALHO
    echo AJUDA - SISTEMA
    echo.
    echo [1] Informacoes do Sistema  - Executa 'systeminfo' mostra dados de SO e patch.
    echo [2] Informacoes de Hardware - Exibe CPU, RAM, Discos, GPU e placa-mae via PowerShell.
    echo [3] Espaco em Disco         - Lista volumes e espaco livre (PowerShell).
    echo [4] Diagnostico de Memoria - Inicia mdsched.exe (reinicio necessario para teste).
    echo [5] Reparar SFC             - Executa 'sfc /scannow' (pode pedir reinicio).
    echo [6] Criar Ponto de Restauracao - Tenta Checkpoint-Computer (PowerShell).
    echo.
    echo Observacoes: algumas operations requerem privilegios de administrador.
    pause
    goto MENU_SISTEMA
:: ==== FIM AJUDA - SISTEMA =======================================
::///////////////////////////////////////////////////////////////////////////////
:: ------ AJUDA - REDE --------------------------------------------
:AJUDA_REDE
    cls
    call :CABECALHO
    echo AJUDA - REDE
    echo.
    echo [1] Teste Ping de Internet  - Faz ping para hosts conhecidos e testa DNS local.
    echo [2] IPConfig                - Mostra configuracao IP basica.
    echo [3] IPConfig /All           - Mostra detalhes completos (DNS, adaptadores).
    echo [4] Tracert                 - Rastreia rota ate o destino (forneca dominio/ip).
    echo [5] Netstat                 - Mostra conexoes/portas ativas.
    echo [6] Flush DNS               - Limpa cache DNS (uso seguro).
    echo [7] Reset Completo de Rede  - Reseta TCP/IP, Winsock, renova IP (interrompe rede).
    echo [8] Redes Wi-Fi             - Lista redes Wi-Fi visiveis (netsh wlan).
    echo [9] Teste de Velocidade     - Abre speedtest.net no navegador.
    echo [10] Meu IP                 - Abre site que mostra IP publico.
    echo [11] Ping Manual            - Submenu para configurar e executar ping custom.
    echo [12] Comparilhamento de Arquivos - Abre gui de compartilhamento de arquivos.
    echo [13] Adaptadores de Rede     - Abre configuracao de adaptadores de rede.
    echo [14] LOG de Redes (3 ultimos dias) - Exibe log de redes recentes.
    echo.
    echo Aviso: reset completo de rede desconecta temporariamente; use com cuidado.
    pause
    goto MENU_REDE
:: ==== FIM AJUDA - REDE ==========================================
::///////////////////////////////////////////////////////////////////////////////
:: ------ AJUDA - SEGURANCA -------------------------------------- 
:AJUDA_SEGURANCA
    cls
    call :CABECALHO
    echo AJUDA - SEGURANCA
    echo.
    echo [1] Ativar Firewall         - Ativa Windows Firewall para todos perfis.
    echo [2] Desativar Firewall      - Desativa (confirmacao recomendada).
    echo [3] Status Defender         - Mostra status do service WinDefend.
    echo [4] Atualizar Defender      - Forca atualizacao de definicoes (MpCmdRun).
    echo [5] Varredura Rapida        - Scans rapidos via MpCmdRun.
    echo [6] Varredura Completa      - Varredura completa (pode demorar).
    echo [7] Verificar BitLocker     - Mostra status do BitLocker (manage-bde).
    echo [8] Desativar SMB1          - Remove suporte a SMBv1 (recomendado por seguranca).
    echo [9] Verificar Atualizacoes  - Lista quantidade de hotfixes de seguranca instalados.
    echo [10] Desabilitar UAC        - Desativa Controle de Conta de Usuario (reinicio necessario).
    echo.
    echo Observacao: trocar configuracoes de seguranca pode afetar compatibilidade.
    pause
    goto MENU_SEGURANCA
:: ==== FIM AJUDA - SEGURANCA ====================================
::///////////////////////////////////////////////////////////////////////////////
:: ------ AJUDA - MANUTENCAO -------------------------------------
:AJUDA_MANUTENCAO
    cls
    call :CABECALHO
    echo AJUDA - MANUTENCAO
    echo.
    echo [1] Limpar Arquivos Temporarios - Remove temporarios do usuario e sistema.
    echo [2] Limpeza de Disco Avancada   - Abre cleanmgr com configuracoes.
    echo [3] Otimizar Disco              - Defrag/otimizacao (HDD/SSD difere).
    echo [4] Verificar Erros do Sistema - chkdsk (pode exigir reinicio).
    echo [5] Windows Update              - Abre configuracao de updates.
    echo [6] Visualizar Log de Suporte  - Exibe o arquivo de log do script.
    echo [7] Reiniciar Explorer         - Reinicia processo explorer.exe.
    echo [8] Forcar updates             - Forca atualizacao de politicas de grupo.
    echo.
    echo Uso: algumas acoes podem demorar e/ou exigir reinicio do sistema.
    pause
    goto MENU_MANUTENCAO
:: ==== FIM AJUDA - MANUTENCAO ===================================
::///////////////////////////////////////////////////////////////////////////////
:: ------ AJUDA - FERRAMENTAS ----------------------------------- 
:AJUDA_FERRAMENTAS
    cls
    call :CABECALHO
    echo AJUDA - FERRAMENTAS
    echo.
    echo [1] Gerenciador de Tarefas  - Abre taskmgr.
    echo [2] Gerenciador de Dispositivos - Abre devmgmt.msc.
    echo [3] Editor do Registro      - Abre regedit (use com cautela).
    echo [4] PowerShell              - Abre console PowerShell.
    echo [5] Servicos do Windows    - Abre services.msc.
    echo [6] Visualizador de Eventos- Abre eventvwr.msc.
    echo [7] MSCONFIG                - Abre msconfig.
    echo [8] Visualizador de Eventos Grafico - Abre perfmon /rel.
    echo [9] Painel de Controle      - Abre control.
    echo [10] Impressoras e Dispositivos - Abre configuracao de impressoras.
    echo [11] Desisntalar Programas  - Abre appwiz.cpl
    echo [12] Politicas de Grupos    - Abre gpedit.msc (se disponivel).
    echo [13] Propriendades do Sistema - Abre sysdm.cpl.
    echo.
    echo Observacao: ferramentas permitem alteracoes sensiveis no sistema.
    pause
    goto MENU_FERRAMENTAS
:: ==== FIM AJUDA - FERRAMENTAS ==================================
::///////////////////////////////////////////////////////////////////////////////