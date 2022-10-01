#!/bin/bash

# Função do Menu incial
menu_Start(){
	clear_screen
	
	echo " ---------------------------------------------------------------------------"
    echo "|                                                                           |"
	echo "|            -------------------------------------------------              |"
	echo "|           |               Fábrica OpenSSL                   |             |"
	echo "|            -------------------------------------------------              |"
	echo "|                                                                           |"
	echo "|                      CIFRAR FICHEIROS E MENSAGENS                         |"
	echo "|            -------------------------------------------------              |"
	echo "|           | 1 - RC4 (little used)                           |             |"                          
	echo "|           | 2 - AES 128                                     |             |"
	echo "|           | 3 - AES 256                                     |             |"
	echo "|           | 4 - BASE 64                                     |             |"
	echo "|            -------------------------------------------------              |"
	echo "|                                                                           |"
	echo "|                               CALCULAR                                    |"
	echo "|            -------------------------------------------------              |"
	echo "|           | 5 - CALCULO DO HASH                             |             |"
	echo "|           | 6 - CALCULO E VERIFICAÇÃO DO HMAC               |             |"
	echo "|            -------------------------------------------------              |"
	echo "|                                                                           |"
	echo "|                  GERAR CHAVES          GERAR CERTIFICADOS                 |"
	echo "|            -------------------------------------------------              |"
	echo "|           | 7 - CHAVE RSA         |        8 - CERTIFICADOS |             |"
	echo "|            -------------------------------------------------              |"
	echo "|                                                                           |"
	echo "|                         ASSINATURAS DIGITAIS                              |"
	echo "|            -------------------------------------------------              |"
	echo "|           | 9 - ASSINATURAS DIGITAIS                        |             |"
	echo "|            -------------------------------------------------              |"
	echo "|                                                                           |"
	echo "|                       COMPARAÇÃO DE FICHEIROS                             |"
	echo "|            -------------------------------------------------              |"
	echo "|           | 10 - COMPARAÇÃO DE FICHEIROS                    |             |"
	echo "|            -------------------------------------------------              |"
	echo "|---------------------------------------------------------------------------|"
	echo "|                                                      -------------------  |"
    echo "|                                                     | 11 - AJUDA        | |" 
    echo "|                                                      -------------------  |" 
    echo " ---------------------------------------------------------------------------"
echo -n  "  Escolha uma das opçoes: ";read option_menu                                

	
	case $option_menu in
	1) menu ;;
	2) menu ;;
	3) menu ;;
	4) menu ;;
	5) menu_HASH ;;
	6) menu_HMAC ;;
	7) menu_RSA ;;
	8) menu_certificate ;;
	9) menu_signature_RSA_SHA256 ;;
   	10) compare_FILES ;;
	11) menu_help ;;
	*) echo "Opção Inválida!"; menu_Start ;;
	esac
}

# Função do Menu Secundário
menu(){
	clear_screen

	# Escolha do titulo
	case $option_menu in
		1)title="REVERSE CRYPTO 4" ;;
		2)title="ADVANCED ENCRYPTION STANDART - 128" ;;
		3)title="ADVANCED ENCRYPTION STANDART - 256" ;;	
		4)title="BASE 64 BYTES"	
	esac
	

	echo $title # Mostra o respetivo titulo do menu
	
	echo ""
	echo    " -------------------------------------------------------------"
	echo    "|                                                             |"
	echo    "|                                                             |"
	echo    "|                                                             |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 1 -> Encriptação                       |          |"
    echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 2 -> Desencriptação                    |          |" 
	echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 3 -> Voltar ao menu anterior           |          |"
	echo    "|          ----------------------------------------           |"
	echo    "|                                                             |"
	echo    " -------------------------------------------------------------"
	echo -n "  Escolha uma das opções: "; read option                              


	# escolha das opções de cifrar e decifrar
	case $option in
	0);;	
	1) encrypt ;;
	2) decrypt ;;
	3) menu_Start ;;
	*) echo "Opção Inválida!"; menu ;;
	esac
	
}

# Função que mostra o menu de cifra RC4, AES-128 e AES-256
encrypt() {
	clear_screen

	echo $title # Mostra o respetivo titulo do menu
    
	echo " .................."
	echo "| 0123456789abcdef |"
	echo " .................."
	echo    " -----------------------------------------------------------------------"
	echo -n "| Insira uma password em Hexadécimal com os caractéres referidos a cima:| ";read CYPHER
	
	# Verifica se foi digitado algum valor, caso não mostra a chave aleatória
	if [[ -z "$CYPHER" ]]; then
	random_key
	echo -n " " $CYPHER; echo""  # mostra a password
	fi

	while [[ ! "$CYPHER" =~ ^(0[xX])?[0-9a-fA-F]+$ ]]; do # =~ verifica os valores dentro de uma array
	  	echo "Password Inválida!"	  	
	  	sleep 2	
	  	encrypt 
  		done

		echo -n "| Insira o nome do ficheiro a ser Cifrado:| "; read IN_FILE 
		echo    " -----------------------------------------"
		
		if [[ -z "$IN_FILE" ]]; then
			clear_screen
			echo $title 
			echo ""
		 	encrypt_MESSAGES;	 	
		fi

		

		echo    " ------------------------------------"
		echo -n "| Insira o nome do ficheiro de Saída:| "; read OUT_FILE
	    echo    " ------------------------------------"

	    	if [[ -z "$OUT_FILE" ]]; then
				echo "O campo do nome do ficheiro não pode ser nulo!"
				sleep 2
				encrypt
			fi

				#create_directory_and_copy_file; # copia os ficheiros para uma pasta

				# Escolha da função para cifrar
				case $option_menu in
				1) algorithm_encryptRC4 # inicia função de cifra de RC4
				   name="RC4" ;; 
				2) algorithm_encryptAES128  # inicia função de cifra de AES-128
				   name="AES-128" ;;
				3) algorithm_encryptAES256 # inicia função de cifra de AES-256
				   name="AES-256" ;; 
				4) algorithm_encrypt_BASE64
				   name="BASE-64" ;;
				esac

				rm "$IN_FILE" # Remove o ficheiro em texto limpo

			    echo " --------------------------"
				echo "| A cifra usada foi:       | " $name 
				echo "| A pasword usada foi:     |  "$CYPHER
				echo "| O ficheiro criado foi:   | " $OUT_FILE
				echo "| O ficheiro excluido foi: | " $IN_FILE
				echo ""
		

	clean_values
	key_back_Menu
	menu_Start
}

# Função para mostrar menu de decifra RC4, AES-128 e AES-256
decrypt() {
	clear_screen

	echo $title # Mostra o respectivo titulo do menu


	echo ""
	echo " -----------------------------------"
    echo -n "| Insira o nome do ficheiro Cifrado:| "; read OUT_FILE
    
    if [[ -e "$OUT_FILE" ]]; then

		echo -n "| Insira o nome para o ficheiro de Saída:| "; read IN_FILE

		if [[ -z "$IN_FILE" ]]; then
			echo "O campo do nome não pode ser vazio!"
			sleep 2
	  		decrypt
		fi
		echo -n "| Insira a password:| "; read CYPHER
		if [[ -z "$CYPHER" ]]; then
			echo "A password não pode ser nula!"
			sleep 2
	  		decrypt
		fi
	    echo "-------------------"

		# Escolha de função para decifrar
		case $option_menu in
		1) algorithm_decryptRC4 ;; # inicia função de decifra de RC4
		2) algorithm_decryptAES128 ;; # inicia função de decifra de AES-128
		3) algorithm_decryptAES256 ;; # inicia função de decifra de AES-256
		4) algorithm_decrypt_BASE64 ;;
		esac

		rm "$OUT_FILE" # Remove o ficheiro cifrado

	    echo " -------------------------"
		echo "| A password usada foi:   |" $CYPHER 
		echo "| O ficheiro criado foi:  |" $IN_FILE
		echo "| O ficheiro excluido foi:|" $OUT_FILE
		echo ""	

	else
		echo "O Ficheiro não foi encontrado!"
		sleep 2
	  	decrypt
	fi
    
    echo""
    clean_values
	key_back_Menu
	menu_Start
}

# ------------------ Funções para Encriptar e Desencriptar --------------------
algorithm_encryptRC4(){ 
	if [[ -z "$IN_FILE" ]]; then
		echo -n "$MESSAGE" | openssl enc -rc4 -e -K "$CYPHER" 
		else
		openssl enc -rc4 -e -K "$CYPHER" -in "$IN_FILE" -out "$OUT_FILE" 
	fi	
}

algorithm_encryptAES128(){
	if [[ -z "$IN_FILE" ]]; then
		echo -n "$MESSAGE" | openssl enc -aes128 -e -K "$CYPHER" -iv 0
		else
		openssl enc -aes128 -K "$CYPHER" -in "$IN_FILE" -out "$OUT_FILE" -iv 0 
	fi		
}

algorithm_encryptAES256(){
	if [[ -z "$IN_FILE" ]]; then
		echo -n "$MESSAGE" | openssl enc -aes256 -e -K "$CYPHER" -iv 0
		else
		openssl enc -aes256 -K "$CYPHER" -in "$IN_FILE" -out "$OUT_FILE" -iv 0 
	fi
	
}

algorithm_encrypt_BASE64(){
	if [[ -z "$IN_FILE" ]]; then
		echo -n "$MESSAGE" | openssl enc -base64 -K "$CYPHER" 
		else
		openssl enc -base64 -K "$CYPHER" -in "$IN_FILE" -out "$OUT_FILE"  
	fi
}

algorithm_decryptRC4(){ 
	openssl enc -rc4 -d -K "$CYPHER" -in "$OUT_FILE" -out "$IN_FILE"
}


algorithm_decryptAES128(){	
	openssl enc -aes128 -d -K "$CYPHER" -in "$OUT_FILE" -out "$IN_FILE" -iv 0
}


algorithm_decryptAES256(){	
	openssl enc -aes256 -d -K "$CYPHER" -in "$OUT_FILE" -out "$IN_FILE" -iv 0
}
 
algorithm_decrypt_BASE64(){
    openssl enc -base64 -d -K "$CYPHER" -in "$OUT_FILE" -out "$IN_FILE" 
}

encrypt_MESSAGES(){
if [[ -z "$IN_FILE" ]]; then
	echo    " -------------"
	echo -n "| Mensagem:   | "; read MESSAGE
	echo -n "| Criptograma:|  "

	case $option_menu in
	1) algorithm_encryptRC4 ;; 
	2) algorithm_encryptAES128 ;;
	3) algorithm_encryptAES256 ;; 
	4) algorithm_encrypt_BASE64 ;;
	esac
	
	echo ""
	key_back_Menu 
	menu
fi
}

#---------------------------------------------------------------------------------

# função do menu que mostra as opções para escolher o tipo de hash a ser utilizado
menu_HASH(){
	clear_screen
	case $option_menu in
		5)title="MESSAGE DIGEST ALGORITHM" ;;
    esac

    echo $title

    echo ""
   	echo    " -------------------------------------------------------------"
	echo    "|                                                             |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 1 -> MD                                |          |"
    echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 2 -> SHA                               |          |" 
	echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 3 -> Voltar ao menu anterior           |          |"
	echo    "|          ----------------------------------------           |"
	echo    "|                                                             |"
    echo    " -------------------------------------------------------------"
	echo -n "  Escolha uma das opções: "; read option_hash                          
	echo ""
	

    # Escolha do menu para calcular o hash 
	case $option_hash in 
		1) menu_MD ;; # cálculo mdi
		2) menu_SHA ;; # cálculo sha-1
		3) menu_Start ;;
        *) echo "Opção Inválida!"; menus ;;
	esac
	
}

# mostra o menu de caicular o hash em md5 e sh-1

menu_MD(){
clear_screen

	case $option_menu in
		5)title="SECURE HASHING ALGORITHM MD" ;;
    esac

    echo $title

    echo ""
   	echo    " -------------------------------------------------------------"
	echo    "|                                                             |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 1 -> MD4                               |          |"
    echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 2 -> MD5                               |          |" 
	echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 3 -> Voltar ao menu anterior           |          |"
	echo    "|          ----------------------------------------           |"
	echo    "|                                                             |"
    echo    " -------------------------------------------------------------"
	echo -n "  Escolha uma das opções: "; read option_md                          
	echo ""
	

    # Escolha do menu para calcular o hash 
	case $option_md in 
		1) calc_MD ;;
		2) calc_MD ;;
		3) menu_HASH ;;
        *) echo "Opção Inválida!"; menus ;;
	esac
	
}

calc_MD(){
clear_screen

   

    # Escolha do titulo
	case $option_md in 
		1)title="SECURE HASHING ALGORITHM MD4" ;;
		2)title="SECURE HASHING ALGORITHM MD5" ;;
    esac

	echo $title # Mostra o respectivo titulo do calculo_hash
	echo ""
	echo    " ------------------------------"
	echo -n "| Introduza o nome do ficheiro:| "; read IN_FILE

	if [[ -e "$IN_FILE" ]]; then

    echo    " ------------------------------"

	#Escolha de funções para calcular  o md5 e sha-1
	case $option_md in
		1) algorithm_MD4 ;; # cálculo md4
	    2) algorithm_MD5 ;; # cálculo md5
	  
	esac

	echo ""
	echo "O Hash do ficheiro é:"
	echo ""
	echo $hash #Mostra o valor do hash calculado

	echo ""
	echo    " -------------------"
    echo    "| O hash usado foi: | " $name
    echo ""

     else
    	echo "O Ficheiro não existe!"
    	sleep 2
	  	calc_SHA
    fi

    echo""
	key_back_Menu
	menu_Start
}

menu_SHA(){
	clear_screen
	title="SECURE HASHING ALGORITHM SHA"


     echo $title

    echo ""
   	echo    " -------------------------------------------------------------"
	echo    "|                                                             |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 1 -> SHA1                              |          |"
    echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 2 -> SHA2-224                          |          |"
    echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 3 -> SHA2-256                          |          |" 
	echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 4 -> SHA2-384                          |          |"
    echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 5 -> SHA2-512                          |          |" 
	echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 6 -> Voltar ao menu anterior           |          |"
	echo    "|          ----------------------------------------           |"
	echo    "|                                                             |"
    echo    " -------------------------------------------------------------"
	echo -n "  Escolha uma das opções: "; read option_sha                          
	echo ""
	

    # Escolha do menu para calcular o hash 
	case $option_sha in 
		1) calc_SHA ;;
		2) calc_SHA ;;
		3) calc_SHA ;;
		4) calc_SHA ;;
		5) calc_SHA ;;
		6) menu_HASH ;;
        *) echo "Opção Inválida!"; menus ;;
	esac
	
}

calc_SHA(){
    clear_screen

case $option_sha in
		1)title="SECURE HASHING ALGORITHM SHA1" ;;
		2)title="SECURE HASHING ALGORITHM SHA2-224" ;;
		3)title="SECURE HASHING ALGORITHM SHA2-256" ;;
		4)title="SECURE HASHING ALGORITHM SHA2-384" ;;
		5)title="SECURE HASHING ALGORITHM SHA2-512" ;;
    esac

	echo $title # Mostra o respectivo titulo do calculo_hash
	echo ""
	echo    " ------------------------------"
	echo -n "| Introduza o nome do ficheiro:| "; read IN_FILE

	if [[ -e "$IN_FILE" ]]; then

    echo    " ------------------------------"

	#Escolha de funções para calcular  o md5 e sha-1
	case $option_sha in
		1) algorithm_SHA1-160 ;; # cálculo sha1
		2) algorithm_SHA2-224 ;; # cálculo sha2-224
	    3) algorithm_SHA2-256 ;; # cálculo sha2-256
	    4) algorithm_SHA2-384 ;; # cálculo sha2-384
	    5) algorithm_SHA2-512 ;; # cálculo sha2-512
	esac

	echo ""
	echo "O Hash do ficheiro é:"
	echo ""
	echo $hash #Mostra o valor do hash calculado

	echo ""
	echo    " -------------------"
    echo    "| O hash usado foi: | " $name
    echo ""

     else
    	echo "O Ficheiro não existe!"
    	sleep 2
	  	calc_SHA
    fi

    echo""
	key_back_Menu
	menu_Start
}


#-------------------- Funções que calculam o HASH --------------------------------


algorithm_MD4(){
		hash=`openssl dgst -md4 "$IN_FILE"`
		      echo "$(openssl dgst -md4 "$IN_FILE")" | sed -E "s/MD4\(${IN_FILE}\)\=//g" > "$IN_FILE.md4"
		name="md4"
}

algorithm_MD5(){
		hash=`openssl dgst -md5 "$IN_FILE"`
		      echo "$(openssl dgst -md5 "$IN_FILE")" | sed -E "s/MD5\(${IN_FILE}\)\=//g" > "$IN_FILE.md5"
		name="md5"
}

algorithm_SHA1-160(){
		hash=`openssl dgst -sha1 "$IN_FILE"`
		      echo "$(openssl dgst -sha1 "$IN_FILE")" | sed -E "s/SHA1\(${IN_FILE}\)\=//g" > "$IN_FILE.sha160"
		name="sha1"
}

algorithm_SHA2-224(){		
		hash=`openssl dgst -sha224 "$IN_FILE"`
			  echo "$(openssl dgst -sha224 "$IN_FILE")" | sed -E "s/SHA224\(${IN_FILE}\)\=//g" > "$IN_FILE.sha224"
		name="sha2-224" 
}

algorithm_SHA2-256(){		
		hash=`openssl dgst -sha256 "$IN_FILE"`
			  echo "$(openssl dgst -sha256 "$IN_FILE")" | sed -E "s/SHA256\(${IN_FILE}\)\=//g" > "$IN_FILE.sha256"
		name="sha2-256" 
}

algorithm_SHA2-384(){		
		hash=`openssl dgst -sha384 "$IN_FILE"`
		      echo "$(openssl dgst -sha384 "$IN_FILE")" | sed -E "s/SHA384\(${IN_FILE}\)\=//g" > "$IN_FILE.sha384"
		name="sha2-384" 
}

algorithm_SHA2-512(){		
		hash=`openssl dgst -sha512 "$IN_FILE"`
		       echo "$(openssl dgst -sha512 "$IN_FILE")" | sed -E "s/SHA512\(${IN_FILE}\)\=//g" > "$IN_FILE.sha512" #faz com que só mostre a cadeia de caracteres hash e envia para o ficheiro
		name="sha2-512" 
}	
	

#---------------------------------------------------------------------------------


menu_HMAC(){
	clear_screen

	case $option_menu in
    	6)title="HASHED MESSAGE AUTHENTICATION CODE" ;;
	esac

	echo $title

    echo ""
    echo    " -------------------------------------------------------------"
	echo    "|                                                             |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 1 -> SHA1-160                          |          |"
    echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 2 -> SHA2-256                          |          |"
    echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 3 -> SHA2-512                          |          |" 
	echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 4 -> ENCRYPT HMAC                      |          |" 
	echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 5 -> VERIFICAÇÃO-HMAC                  |          |" 
	echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 6 -> Voltar ao menu anterior           |          |"
	echo    "|          ----------------------------------------           |"
	echo    "|                                                             |"
	echo    " -------------------------------------------------------------"
	echo -n "  Escolha uma das opções: "; read option_hmac                          	
    echo ""  
	
    # Escolha do menu para calcular o hash 
	case $option_hmac in 
		1) calc_HMAC ;; # cálculo sha1-160
		2) calc_HMAC ;; # cálculo sha2-256
		3) calc_HMAC ;; # cálculo sha2-512
		4) encrypt_HMAC ;;
		5) verify_HMAC ;;
		6) menu_Start ;;
        *) echo "Opção Inválida!"; menus ;;
	esac
	
}


calc_HMAC(){
    clear_screen

    # Escolha do titulo
	case $option_hmac in 
		1)title="SECURE HASHING ALGORITHM 160" ;;
		2)title="SECURE HASHING ALGORITHM 256" ;;
		3)title="SECURE HASHING ALGORITHM 512" ;;
    esac
   
	echo $title # Mostra o respectivo titulo do calculo_hash

    echo " .................."
	echo "| 0123456789abcdef |"
	echo " .................."
	echo " -----------------------------------------------------------------------"
echo -n  "| Insira uma password em Hexadécimal com os caractéres referidos a cima:| "; read CYPHER
 	

	while [[ ! "$CYPHER" =~ ^(0[xX])?[0-9a-fA-F]+$ ]]; do # =~ verifica os valores dentro de uma array
	  	echo "Password Inválida!"	  	
	  	sleep 2	
	  	encrypt 
  		done

	echo -n "| Introduza o nome do ficheiro:| "; read IN_FILE
	echo    " ------------------------------"
    
	if [[ -e "$IN_FILE" ]]; then
		
	#Escolha de funções para calcular  o sha256 e o sha512
	case $option_hmac in
    1) algorithm_HMAC-160 ;;
	2) algorithm_HMAC-256 ;;
	3) algorithm_HMAC-512 ;;
	esac

    echo ""
	echo "O Hash do ficheiro é:"
	echo ""
	echo $sha #Mostra o valor hash do hmac calculado

	echo ""
	echo " -------------------"
    echo "| O hmac usado foi: | " $name
	echo""

	else
		echo "O Ficheiro não existe ou pode ter sido removido!"
		sleep 2
		calc_HMAC	
		fi

    echo""
	key_back_Menu
	menu_Start
}

encrypt_HMAC(){
     clear_screen
    # Escolha do titulo
	
       # Escolha do titulo
	case $option_hmac in 
		1)title="ENCRYPT SECURE HASHING ALGORITHM 160" ;;
		2)title="ENCRYPT SECURE HASHING ALGORITHM 256" ;;
		3)title="ENCRYPT SECURE HASHING ALGORITHM 512" ;;
    esac
	

	echo $title # Mostra o respectivo titulo do calculo_hash
	echo ""
	echo    " -----------------------------------------"
	echo -n "| Introduza o nome do ficheiro com o hash:|"; read FILE_HASH
	echo -n "| Introduza a password para cifrar ficheiro com o hash:|"; read CYPHER
	echo -n "| Introduza o nome de saida para ficheiro hash cifrado:|"; read FILE_HASH_ENCRYPT
	echo ""
    echo    " -------------------------------------------------------------"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 1 -> AES-128                           |          |"
    echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 2 -> AES-256                           |          |"
    echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 3 -> AES-512                           |          |" 
	echo    "|          ----------------------------------------           |"
    echo    " -------------------------------------------------------------"
    echo -n "| Escolha uma das opções: |"; read option_hmac;
	
	case $option_hmac in 
		1) encrypt_hash=`openssl enc -aes-128-cbc -K "$CYPHER" -in "$FILE_HASH.hmac160" -out "$FILE_HASH_ENCRYPT.hmac.aes160" -iv 0` ;;
		2) encrypt_hash=`openssl enc -aes-256-cbc -K "$CYPHER" -in "$FILE_HASH.hmac256" -out "$FILE_HASH_ENCRYPT.hmac.aes256" -iv 0` ;;
		3) encrypt_hash=`openssl enc -aes-512-cbc -K "$CYPHER" -in "$FILE_HASH.hmac512" -out "$FILE_HASH_ENCRYPT.hmac.aes512" -iv 0` ;;
    esac

    echo $encrypt_hash

    echo ""
	echo    " -----------------------------"
    echo    "| O ficheiro hash usado foi:  |" $FILE_HASH
	echo -n "| O ficheiro hash cifrado foi:|" | echo "$FILE_HASH_ENCRYPT";
    echo ""

    echo""
	key_back_Menu
	menu_Start
}

verify_HMAC(){

    clear_screen
    # Escolha do titulo
	
    title="VERIFY SECURE HASHING ALGORITHM"
	

	echo $title # Mostra o respectivo titulo do calculo_hash
	echo ""
	echo    " -----------------------------------------"
	echo -n "| Introduza o nome do ficheiro com o hash:|"; read FILE_HASH
	
    echo -n "| Introduza o nome do ficheiro com o hash cifrado:|"; read FILE_ENCRYPT


    algorithm_verify_hmac
   
    
	echo ""
	echo    " -----------------------------"
    echo    "| O ficheiro hash usado foi:  |" $FILE_HASH
	echo -n "| O ficheiro hash cifrado foi:|" $FILE_ENCRYPT;
    echo ""

    echo""
	key_back_Menu
	menu_Start
}



# Funções do calculo do HMAC 160, 256 e 512

algorithm_HMAC-160(){

	sha=`echo  | openssl dgst -sha1 -hmac "$CYPHER" "$IN_FILE"`
	            echo "$(openssl dgst -sha1 -hmac "$CIPHER" "$IN_FILE")" | sed -E "s/HMAC-SHA1\(${IN_FILE}\)\=//g" > "$IN_FILE.hmac160"; #faz com que só mostre a cadeia de caracteres hash e envia para o ficheiro
	name="sha1-160"
}

algorithm_HMAC-256(){
	sha=`echo  | openssl dgst -sha256 -hmac "$CYPHER" "$IN_FILE"`
	             echo "$(openssl dgst -sha256 -hmac "$CIPHER" "$IN_FILE")" | sed -E "s/HMAC-SHA256\(${IN_FILE}\)\=//g" > "$IN_FILE.hmac256"
	name="sha2-256"
}

algorithm_HMAC-512(){
	sha=`echo  | openssl dgst -sha512 -hmac "$CYPHER" "$IN_FILE"`
	             echo "$(openssl dgst -sha512 -hmac "$CIPHER" "$IN_FILE")" | sed -E "s/HMAC-SHA512\(${IN_FILE}\)\=//g" > "$IN_FILE.hmac512"
	name="sha2-512"
}

# Função que verifica o hash
algorithm_verify_hmac(){
diff $FILE_HASH $FILE_ENCRYPT  
}


#----------------------------------------------------------------------------------

menu_RSA() {
	clear_screen

    case $option_menu in
   	7)title="RIVEST SHAMIR ADLEMAN (KEY ENCRYPTION TECNOLOGIC)" ;;
	esac

  

	echo $title
    
    echo ""
  	echo    " -----------------------------------------------------------------"
	echo    "|                                                                 |"
	echo    "|          ---------------------------------------------          |"
	echo    "|         | 1 -> Criar a Chave Privada RSA              |         |"
    echo    "|          ---------------------------------------------          |"
    echo    "|          ---------------------------------------------          |"
	echo    "|         | 2 -> Exportar a Chave Pública RSA           |         |"
    echo    "|          ---------------------------------------------          |"
    echo    "|          ---------------------------------------------          |"
	echo    "|         | 3 -> Criar a Chave Privada e Pública RSA    |         |"
    echo    "|          ---------------------------------------------          |"
    echo    "|          ---------------------------------------------          |"
	echo    "|         | 4 -> Exportar a Chave Pública e Privada RSA |         |"
    echo    "|          ---------------------------------------------          |"
	echo    "|          ---------------------------------------------          |"
	echo    "|         | 5 -> Voltar ao menu anterior                |         |"
	echo    "|          ---------------------------------------------          |"
	echo    "|                                                                 |"
	echo    " -----------------------------------------------------------------"
	echo -n "  Escolha uma das opções: "; read option_menu_rsa                     
	echo "" 

    case $option_menu_rsa in
   	1)title="RIVEST SHAMIR ADLEMAN (PRIVATE KEY ENCRYPTION TECNOLOGIC)" ;;
    2)title="RIVEST SHAMIR ADLEMAN (PUBLIC KEY ENCRYPTION TECNOLOGIC)" ;;
	3)title="RIVEST SHAMIR ADLEMAN (PUBLIC KEY AND PRIVATE KEY ENCRYPTION TECNOLOGIC)" ;;
	esac

	case $option_menu_rsa in
		1)private_Key_RSA ;;
		2)public_Key_RSA ;;
		3)RSA_PRIVATE_KEY-and-PUBLIC_KEY ;;
		4)RSA_EXPORT_PRIVATE_KEY-and-PUBLIC_KEY ;;
		5)menu_Start ;;
		*) echo "Opção Inválida!"
	esac
}

# função que cria a chave privada e apresenta o menu para escolha do número de bits 
private_Key_RSA() {
	 clear_screen

	 echo $title # Mostra o respectivo titulo do RSA

	 echo ""
	 echo    " ----------------------------"
	 echo -n "|Insira um nome para a chave:| "; read KEY_PRIV_FILE

	 if [[ -z "$KEY_PRIV_FILE" ]]; then
	 	echo "O campo da chave não pode ser vazio!"
	 	sleep 2
	 	private_Key_RSA
	 fi

	echo    " ----------------------------"

	echo    " -------------------------------------------------------------"
	echo    "|                                                             |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 1 -> AES-512                           |          |"
    echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 2 -> AES-1024                          |          |" 
	echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 3 -> AES-2048                          |          |" 
	echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 4 -> AES-4096                          |          |"
	echo    "|          ----------------------------------------           |"
	echo    "|                                                             |"
	echo    " -------------------------------------------------------------"
	echo -n "  Escolha uma das opções:";                          
	
	# chama a função para criar a key
    algorithm_private_Key_RSA 
	
    echo ""
	echo    " --------------------"
	echo    "| O Tipo foi:        |" $name
	echo -n "| A chave criada foi:|" $KEY_PRIV_FILE.key	
	echo "" 
	key_back_Menu
	menu_Start	
}

#Funções que gera a chave RSA
algorithm_private_Key_RSA() {
	read option_rsa

	case $option_rsa in
		1)BYTES=`openssl genrsa -aes-256-cbc -out "$KEY_PRIV_FILE.key" 512`
		  name="RSA-AES-512"
		;;
		2)BYTES=`openssl genrsa -aes-256-cbc -out "$KEY_PRIV_FILE.key" 1024` 
		  name="RSA-AES-1024"
		;;
		3)BYTES=`openssl genrsa -aes-256-cbc -out "$KEY_PRIV_FILE.key" 2048` 
		  name="RSA-AES-2048"
		;;
		4)BYTES=`openssl genrsa -aes-256-cbc -out "$KEY_PRIV_FILE.key" 4096` 
		  name="RSA-AES-4096"
		;;
		*) echo "Opção Inválida!" ;;
	esac	
}

# Função que cria a chave pública
public_Key_RSA(){
	 clear_screen

	 echo $title # Mostra o respectivo titulo do RSA

	 echo ""
	 echo    " -----------------------------------------------"
	 echo -n "|Insira o nome do ficheiro com a chave Privada: | "; read KEY_PRIV_FILE

	  if [[ -z "$KEY_PRIV_FILE" ]]; then
	 	echo "O campo da chave não pode ser vazio!"
	 	sleep 2
	 	public_Key_RSA 
	 fi
        echo  "-----------------------------------------------"
        echo ""
	  	echo    " -------------------------------------"
	 	echo -n "|Insira um nome para a chave publica: | "; read KEY_PUB_FILE

	  if [[ -z "$KEY_PUB_FILE" ]]; then
	 	echo "O campo da chave não pode ser vazio!"
	 	sleep 2
	 	public_Key_RSA 
	 fi

	 echo    " ------------------------------------"
	  
	  # chama a função para criar a chave pública
     algorithm_RSA_EXPORT_PUBLIC_KEY |

     echo    " -----------------------------"
     echo    "| A chave Privada usada foi:  |" $KEY_PRIV_FILE.key
	 echo -n "| A chave Pública criada foi: |" $KEY_PUB_FILE.pem;
	
	 echo "" 
	key_back_Menu
	menu_Start	
}

# função que cria a chave pública
algorithm_RSA_EXPORT_PUBLIC_KEY() {
	 openssl rsa -in "$KEY_PRIV_FILE.key" -outform PEM -pubout -out "$KEY_PUB_FILE.pem"
}



# função que cria a chave privada e apresenta o menu para escolha do número de bits 
RSA_PRIVATE_KEY-and-PUBLIC_KEY() {
	 clear_screen

	 echo $title # Mostra o respectivo titulo do RSA

    echo ""
	echo    " -------------------------------------------------------------"
	echo    "|                                                             |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 1 -> AES-512                           |          |"
    echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 2 -> AES-1024                          |          |" 
	echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 3 -> AES-2048                          |          |" 
	echo    "|          ----------------------------------------           |"
	echo    "|          ----------------------------------------           |"
	echo    "|         | 4 -> AES-4096                          |          |"
	echo    "|          ----------------------------------------           |"
	echo    "|                                                             |"
	echo    " -------------------------------------------------------------"
	echo -n "  Escolha uma das opções:";                          
	
	# chama a função para criar a key pública e privada
    algorithm_pub_key-and-private_Key_RSA
	echo ""
	echo "----------------------------------------------"
	echo -n "Insira um nome para a chave Publica e Privada |"; read KEY_PUB_and_PRIV;
   
    mv sk-and-pk.pem "$KEY_PUB_and_PRIV.pem"

	echo    " --------------------"
	echo    "| O Tipo foi:        |" $name
	echo -n "| A chave Pública e Privada criada foi:|" $KEY_PUB_and_PRIV.pem	
	echo "" 
	key_back_Menu
	menu_Start	
}

#Funções que gera a chave Privada e Publica RSA
algorithm_pub_key-and-private_Key_RSA() {
	read option_rsa

	case $option_rsa in
		1)BYTES=`openssl genrsa -aes-256-cbc -out sk-and-pk.pem 512`
		  name="RSA-AES-512"
		;;
		2)BYTES=`openssl genrsa -aes-256-cbc -out sk-and-pk.pem 1024` 
		  name="RSA-AES-1024"
		;;
		3)BYTES=`openssl genrsa -aes-256-cbc -out sk-and-pk.pem 2048` 
		  name="RSA-AES-2048"
		;;
		4)BYTES=`openssl genrsa -aes-256-cbc -out sk-and-pk.pem 4096` 
		  name="RSA-AES-4096"
		;;
		*) echo "Opção Inválida!" ;;
	esac	
}

# Função que cria a chave pública de Chave Publica e Privada
RSA_EXPORT_PRIVATE_KEY-and-PUBLIC_KEY(){
	 clear_screen

	 echo $title # Mostra o respectivo titulo do RSA

	 echo ""
	 echo    " ---------------------------------------------------------"
	 echo -n "|Insira o nome do ficheiro com a chave Publica e Privada: | "; read KEY_PUB_and_PRIV
	 if [[ -e "$KEY_PUB_and_PRIV.pem" ]]; then
	  if [[ -z "$KEY_PUB_and_PRIV.pem" ]]; then
	 	echo "O campo da chave não pode ser vazio!"
	 	sleep 2
	    RSA_EXPORT_PRIVATE_KEY-and-PUBLIC_KEY
	 fi
        echo  "--------------------------------------------------------"
        echo ""
	  	echo    " -------------------------------------"
	 	echo -n "|Insira um nome para a chave publica: | "; read KEY_PUB
	  
	  
	  # chama a função para criar a chave pública
        algorithm_RSA_EXPORT_PUBLIC_and_PRIV_KEY

    else
    	echo "A chave Publica e Privada não existe!"
	 	sleep 2
	 	RSA_EXPORT_PRIVATE_KEY-and-PUBLIC_KEY
	 fi

     echo    " -----------------------------"
     echo    "| A chave Privada usada foi:  |" $KEY_PUB_and_PRIV.pem
	 echo -n "| A chave Pública criada foi: |" $KEY_PUB.pem
	
	 echo "" 
	 key_back_Menu
	 menu_Start	
}

# função que cria a chave pública de chave Publica e Privada
algorithm_RSA_EXPORT_PUBLIC_and_PRIV_KEY() {
	 openssl rsa -in "$KEY_PUB_and_PRIV.pem" -out "$KEY_PUB.pem" -pubout
}





# função que mostra  o menu para criar uma assinatura
menu_signature_RSA_SHA256(){
	clear_screen

    case $option_menu in
   	9)title="RIVEST SHAMIR ADLEMAN - SECURE HASHED ALGORITHM (DIGITAL SIGNATURE)" ;;
	esac

	echo $title
  
    echo ""
    echo    " ---------------------------------------------------------------------"
    echo    "|          ------------------------------------------------           |"
	echo    "|         | 1 -> Criar uma nova Assinatura Digital         |          |"
    echo    "|          ------------------------------------------------           |"
	echo    "|          ------------------------------------------------           |"
	echo    "|         | 2 -> Calcular Assinaturas Digitais RSA-SHA256  |          |"
    echo    "|          ------------------------------------------------           |"
	echo    "|          ------------------------------------------------           |"
	echo    "|         | 3 -> Verificar Assinaturas Digitais RSA-SHA256 |          |" 
	echo    "|          ------------------------------------------------           |"
	echo    "|          ------------------------------------------------           |"
	echo    "|         | 4 -> Voltar ao menu anterior                   |          |"
	echo    "|          ------------------------------------------------           |"
	echo    "|                                                                     |"
	echo    " ---------------------------------------------------------------------"
	echo -n "  Escolha uma das opções:"; read option_menu_assignature                         
	echo "" 

	case $option_menu_assignature in
		1) create_signature ;;
		2) calc_signature_RSA-SHA256 ;;
		3) verify_signature_RSA-SHA256 ;;
		4) menu_Start ;;
		*) echo "Opção Inválida!"
	esac
}

# função que cria a assinatura
create_signature(){
	clear_screen
	title1="RIVEST SHAMIR ADLEMAN - SECURE HASHED ALGORITHM (CREATE DIGITAL SIGNATURE)"

	echo $title1 # Mostra o respectivo titulo do calculo_hash
	echo ""
	echo    " --------------------------------"
	echo -n "| Insira o nome do ficheiro:     | "; read IN_FILE
	if [[ -e "$IN_FILE" ]]; then
	echo -n "| Insira o nome da chave Privada:| "; read KEY_PRIV_FILE
    if [[ -e "$KEY_PRIV_FILE.key" ]]; then
	echo -n "| Insira o nome para criar a Assinatura | "; read SIGN

	if [[ -z "$SIGN" ]]; then
		echo "O campo da chave não pode ser vazio!"
	 	sleep 2
	 	create_signature
	fi

    else
		echo "O ficheiro não foi encontrado ou pode ter sido removido!"
	 	sleep 2
	 	create_signature
	fi

 	echo    " ----------------------------------------"
        
    openssl dgst -sha256 -sign "$KEY_PRIV_FILE.key" -out `echo "$SIGN.sign $IN_FILE"`	
    
     else  
     	echo "A chave privada não foi encontrada ou pode ter sido Removida!"
     	sleep 2
     	create_signature
     fi

    echo ""
	echo    " ---------------------------"
	echo    "| O Ficheiro usado foi:     | " $IN_FILE
    echo    "| A Chave Privada usada foi:| " $KEY_PRIV_FILE.key
	echo -n "| A Assinatura creada foi:  | " $SIGN.sign
	echo""
	
	key_back_Menu
	menu_Start
}

# função que calcula a assinatura
calc_signature_RSA-SHA256(){
	clear_screen
	title2="RIVEST SHAMIR ADLEMAN - SECURE HASHED ALGORITHM (CALCULATE DIGITAL SIGNATURE)"

	echo $title2 # Mostra o respectivo titulo do calculo_hash
	echo ""
	echo    " ----------------------------------------------------------------"
	echo -n "| Insira o nome do ficheiro para calcular a Assinatura Digital:  | "; read IN_FILE
	if [[ -e "$IN_FILE" ]]; then
	echo -n "| Insira nome da Assinatura digital:| "; read SIGN
	if [[ -e "$SIGN.sign" ]]; then
		echo -n "| Insira nome da Key Privada e Pública:| "; read KEY_PRIV_and_PUB
    echo -n "| Insira o nome para o ficheiro de saída:| "; read OUT_FILE
 	echo    " ----------------------------------------------------------------"

	 else
     	echo "A Assinatura não existe ou pode ter sido removida!"
	 	sleep 2
	 	calc_signature_RSA-SHA256
	 fi	

	   else
     	echo "A chave Privada e Publica não existe ou pode ter sido removido!"
	 	sleep 2
	 	calc_signature_RSA-SHA256
	 fi	
     

     echo "$(openssl dgst -sha256 "$IN_FILE")" | sed -E "s/HMAC-SHA256\(${IN_FILE}\)\=//g"  > "$SIGN.sha256"    
             openssl rsautl -sign -in "$SIGN.sha256" -out "$OUT_FILE.hash" -inkey "$KEY_PRIV_and_PUB.pem"
    
	echo ""
	echo " -------------------------"
    echo "| A ficheiro usado foi:   |" $IN_FILE
	echo "| A Assinatura usada foi: |" $SIGN.sign
    echo "| A chave Privada e Publica foi:|" $KEY_PRIV_and_PUB.pem
    echo "| O ficheiro criado foi:  |" $OUT_FILE.hash 
	echo""


    echo""
	key_back_Menu
	menu_Start
}

# função que verifica a assinatura
verify_signature_RSA-SHA256(){
	clear_screen
	title3="RIVEST SHAMIR ADLEMAN - SECURE HASHED ALGORITHM (VERIFY CREATE DIGITAL SIGNATURE)"

	echo $title3 # Mostra o respectivo titulo do calculo_hash
	echo ""
	echo    " -----------------------------------"
	
	echo -n "| Insira o ficheiro de hash cifrado:| "; read HASH
  
	if [[ -e "$HASH.hash" ]]; then

    echo -n "| Insira o nome da chave publica:| "; read KEY_PUB_FILE

    if [[ -e "$KEY_PUB_FILE.pem" ]]; then

    echo -n "| Insira o nome para o ficheiro de saída:  | "; read OUT_FILE

    if [[ -z "$OUT_FILE" ]]; then

     	echo "O campo da chave não pode ser vazio!"
	 	sleep 2
	 	verify_signature_RSA-SHA256
	 fi
   # consertar erro 
    openssl rsautl -verify -in "$HASH.hash" -out "$OUT_FILE" -inkey "$KEY_PUB_FILE.pem" -pubin;
    
	echo ""
    echo  "----------------------------"
    echo "| A ficheiro hash usado foi: |" $HASH.hash
	echo "| A chave Pública usada foi: |" $KEY_PUB_FILE.pem
    echo "| O ficheiro criado foi:     |" $OUT_FILE
 echo -n "| O hash gerado foi:|"; cat $OUT_FILE;
	echo""
		
		 else
	     	echo "O Ficheiro HASH não existe ou pode ter sido removido!"
		 	sleep 2
		 	verify_signature_RSA-SHA256
		 fi	

	  else
     	echo "A chave publica não existe ou pode ter sido removida!"
	 	sleep 2
	 	verify_signature_RSA-SHA256
	 fi	

    echo""
	key_back_Menu
	menu_Start
}

# função que mostra  o menu para criar e verificar Certificados 
menu_certificate(){
	clear_screen

    case $option_menu in
   		8)title="CERTIFICADOS" ;;
	esac

	echo $title
  
    echo ""
    echo    " --------------------------------------------------------------------"
	echo    "|                                                                    |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         | 1 -> Geração de pedidos de Certificação       |          |"
    echo    "|          -----------------------------------------------           |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         | 2 -> Criar Certificado x.509                  |          |"
    echo    "|          -----------------------------------------------           |"
    echo    "|          -----------------------------------------------           |"
	echo    "|         | 3 -> Criar Encadeamento de Certificados       |          |"
    echo    "|          -----------------------------------------------           |"
    echo    "|          -----------------------------------------------           |"
	echo    "|         | 4 -> Verificar Certificados                   |          |"
    echo    "|          -----------------------------------------------           |"
    echo    "|          -----------------------------------------------           |"
	echo    "|         | 5 -> Voltar                                   |          |"
    echo    "|          -----------------------------------------------           |"
	echo    " --------------------------------------------------------------------"
	echo -n "  Escolha uma das opções:"; read option_menu_assignature                         
	echo "" 

	case $option_menu_assignature in
		1) request_certificate ;;
		2) create_certificate_X.509 ;;
		3) management_certificates ;;
		4) verify_certificates ;;
		5) menu_Start ;;
		*) echo "Opção Inválida!"
	esac
}

# fubção que faz o pedido do certificado
request_certificate(){
clear_screen
	title="REQUEST CERTIFICATE DIGITAL"

	echo $title # Mostra o respectivo titulo do calculo_hash
	echo ""
	echo    " ------------------------------------------------"
	echo -n "| Insira um nome do ficheiro com a chave Privada:| "; read KEY_PRIV_FILE
    echo    " ------------------------------------------------"

	echo -n "| Insira o nome para criar o Certeficado de Pedido CSR:| "; read CERTEFICATE_REQUEST
	
	openssl req -new -sha256 -key "$KEY_PRIV_FILE.key"  -out "$CERTEFICATE_REQUEST.csr" 

	echo ""
	echo    " --------------------------------------"
    echo    "| O certicado de pedido CSR criado foi:| "$CERTEFICATE_REQUEST.csr
	echo""

	key_back_Menu
	menu_Start
}

# função que cria o certificado X.509 Principal
create_certificate_X.509(){
	clear_screen
	title="CREATE CERTIFICATE DIGITAL"

	echo $title # Mostra o respectivo titulo do calculo_hash
	echo ""
	echo    " ------------------------------------------------"
	echo -n "| Insira um nome do ficheiro com a chave Privada:| "; read KEY_PRIV_FILE
	echo -n "| Insira o número de dias para o Certificado:    | "; read CERTEFICATE_DAYS
 	echo -n "| Insira o ficheiro com o certificado de pedido CSR:| "; read CERTEFICATE_CSR 
    echo -n "| Insira o nome para criar o certificado CRT:| "; read CERTEFICATE_CRT
    

    openssl x509 -trustout -signkey "$KEY_PRIV_FILE.key" -days "$CERTEFICATE_DAYS" -req -sha256 -in "$CERTEFICATE_CSR.csr" -out "$CERTEFICATE_CRT.crt"  
 

	echo ""
	echo    " --------------------------------"
    echo    "| A chave Privada usada foi:     | " $KEY_PRIV_FILE.key
    echo    "| A validade do Certeficado é de:| " $CERTEFICATE_DAYS
    echo    "| O Certeficado usado foi:       | " $CERTEFICATE_CSR.csr 
    echo    "| O Certeficado CRT criado foi:  | " $CERTEFICATE_CRT.crt 
    echo    " --------------------------------"
	echo""

	key_back_Menu
	menu_Start
}

#-------------------------------------------------------------------------------------------
# função para fazer o encadeamento de certificados
management_certificates(){
	clear_screen
	title="MANAGEMENT CERTIFICATE DIGITAL"

	echo $title # Mostra o respectivo titulo do calculo_hash
	echo ""

	count=1;

	echo    " --------------------------------------------"
	echo -n "| Insira o número de certeficados a encadear:| "; read NUMBER_OF_CERTEFICATES


	while [ "$count" -le "$NUMBER_OF_CERTEFICATES" ]; do
    
	echo    " ------------------------------------------------------"
	echo -n "| Insira o número de dias para o Certificado:          | "; read CERTEFICATE_DAYS
	echo -n "| Insira o ficheiro com o certificado  de pedido CSR:  | "; read CERTEFICATE_CSR 
	echo -n "| Insira o nome do principal certificado CRT:          | "; read CERTEFICATE_CRT
	echo -n "| Insira um nome do ficheiro com a chave Privada:      | "; read KEY_PRIV_FILE
	echo -n "| Insira o nome para criar o certificado Endadeado CRT:| "; read CERTEFICATE_CRT_OUT
	echo    " ------------------------------------------------------"
	
	openssl x509 -req -days "$CERTEFICATE_DAYS" -in "$CERTEFICATE_CSR.csr" -CA "$CERTEFICATE_CRT.crt" -CAkey "$KEY_PRIV_FILE.key" -set_serial 01 -out "$CERTEFICATE_CRT_OUT.crt" -sha256
    
    openssl verify -trusted `echo "$CERTEFICATE_CRT.crt" "$CERTEFICATE_CRT_OUT.crt"`
    
    cat "$CERTEFICATE_CRT_OUT.crt" >> .temp.tp # envia para o temp cada chave criada
    let count++;

	done
    
    echo     "-------------------------------------------"	
	echo -n "| Insira o nome para o certificado de saída:| "; read OUT_FILE_CERTEFICATE
	
	cp .temp.tp "$OUT_FILE_CERTEFICATE.chain"
	rm  .temp.tp
	
	echo ""
    echo    "| O número de certificados encadeados foi:| " $NUMBER_OF_CERTEFICATES
    echo    " -----------------------------------------"
    echo    " -------------------------"
    echo    "| O certificado criado foi:|" $OUT_OF_CERTEFICATE.crt

	echo""
    
	key_back_Menu
	menu_Start

}

# função que verifica um certificado Individual usando o certificado principal 
verify_certificates(){
clear_screen
	title="VERIFY CERTIFICATE DIGITAL"

	echo $title # Mostra o respectivo titulo do calculo_hash
	echo ""
	echo    " ----------------------------------------------------"
	echo -n "| Insira o nome do Certificado que pretende Verificar:| "; read NAME_OF_CERTIFICATE 
    echo -n "| Insira o ficheiro com o certeficado CRT:   | "; read CERTEFICATE_CRT
    openssl verify -trusted `echo "$CERTEFICATE_CRT.crt" "$NAME_OF_CERTIFICATE.chain"`

	echo""
    
	key_back_Menu
	menu_Start
}

# função que compara o hash de 2 ficheiros
compare_FILES() {
 	 clear_screen
	 title="COMPARE TO FILES"
	 echo $title # Mostra o respectivo titulo do RSA

	 echo ""
	 echo    " --------------------------------------------"
	 echo -n "| Insira o nome do ficheiro sem ser cifrado: | "; read FILE
	
	if [[ -e "$FILE" ]]; then

		 echo -n "| Insira o nome do ficheiro cifrado:     | "; read FILE_ENCRYPT

     else
     	echo "O ficheiro não existe ou pode ter sido removido!"
	 	sleep 2
	 	compare_FILES
	 fi

         echo ""
		 algorithm_compare_FILES 
		 
		 echo -n "|O ficheiro usado foi:|" $FILE|
		 echo -n "|O ficheiro cifrado foi:  |" $FILE_ENCRYPT|
	     echo ""
    
	
     
    echo""
	key_back_Menu
	menu_Start
}

# função de algoritmo de comparação de dois ficheiros
algorithm_compare_FILES(){
diff $FILE $FILE_ENCRYPT
}

# Limpa a tela do terminal 
clear_screen(){
	clear
}

# Gera uma chave Aleatória e guarda na Variavél CIPHER
random_key(){
	case $option_menu in
	1) CYPHER=`openssl rand -hex 16` ;;
	2) CYPHER=`openssl rand -hex 16` ;;
    3) CYPHER=`openssl rand -hex 32` ;;
    4) CYPHER=`openssl rand -hex 64` ;;
esac
}

# função para primir enter
key_back_Menu(){
 	echo -n "Prima <ENTER> para voltar ao Menu anterior"; read ENTER
}

# funcão para limpar variavéis
clean_values(){
CYPHER=""
IN_FILE=""
OUT_FILE=""
}


#encrypt_create_directory_and_copy_file(){
#	case "$option_menu" in
#		1) mkdir EncryptRC4;
#		 if [[ -e EncryptRC4 ]]; then 
#	       cp "$OUT_FILE" EncryptRC4 | rm "$OUT_FILE"; 
#	     else 
#	     	mkdir EncryptRC4 | cp "$OUT_FILE" EncryptRC4 | rm "$OUT_FILE";
#	      fi  
#esac 
#;;
#}


#decrypt_create_directory_and_copy_file(){
#case "$option_menu" in
#		1) mkdir DecryptRC4;
#		 if [[ -e DecryptRC4 ]]; then 
#	       cp "$OUT_FILE" DecryptRC4 | rm "$OUT_FILE"; 
#	     else 
#	     	mkdir DecryptRC4 | cp "$OUT_FILE" DecryptRC4 | rm "$OUT_FILE";
#	      fi  
#esac
#}








menu_help(){
	clear_screen

    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |"
    echo    "|                              AJUDA                                 |"
	echo    "|                                                                    |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         | 1 -> Cifrar ficheiros e mensagens             |          |"
    echo    "|          -----------------------------------------------           |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         | 2 -> Funções de hash                          |          |"
    echo    "|          -----------------------------------------------           |"
    echo    "|          -----------------------------------------------           |"
	echo    "|         | 3 -> Chaves RSA                               |          |"
    echo    "|          -----------------------------------------------           |"
    echo    "|          -----------------------------------------------           |"
	echo    "|         | 4 -> Certificados Digitais                    |          |"
    echo    "|          -----------------------------------------------           |"
    echo    "|          -----------------------------------------------           |"
	echo    "|         | 5 -> Assinaturas Digitais                     |          |"
    echo    "|          -----------------------------------------------           |"
    echo    "|          -----------------------------------------------           |"
	echo    "|         | 6 -> Comparação de ficheiros                  |          |"
    echo    "|          -----------------------------------------------           |"
    echo    "|          -----------------------------------------------           |"
	echo    "|         | 0 -> Regressar ao menu principal              |          |"
    echo    "|          -----------------------------------------------           |"
    echo    "|                                                                    |"
	echo    " --------------------------------------------------------------------"

	echo -n "  Escolha uma das opções:"; read option_help                        
	echo "" 

	case $option_help in
		1) cifrar_ficheiros ;;
		2) funcoes_hash ;;
		3) chaves_RSA ;;
		4) certificados_digitais ;;
		5) assinatura_digital ;;
		6) comparacao_ficheiros ;;
		0) menu_Start ;;
		*) echo "Opção Inválida!"
	esac
}

cifrar_ficheiros(){
	clear_screen
    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |"
    echo    "|                              AJUDA                                 |"
	echo    "|                                                                    |"
	echo    "|    -------------------------------------------------------------   |"
	echo    "|   |               Cifrar ficheiros e mensagens                  |  |"
    echo    "|    -------------------------------------------------------------   |"
    echo    "|                                                                    |"
    echo    "|      Nesta seção do programa, será lhe possibilitada a cifra       |"
    echo    "|        e decifra de ficheiros, recorrendo a alguns algoritmos      |"
    echo    "|        de criptografica.                                           |"
    echo "   |                                                                    |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         |             RC4 - Rivest Cipher 4             |          |"
    echo    "|          -----------------------------------------------           |"
    echo    "|                                                                    |"    
    echo    "|          Cifra de chave simétrica contínua, aceita                 |"
    echo    "|               uma chave de 128 bits.                               |"
    echo    "|                                                                    |"
    echo    "|         COMANDOS                                                   |"
    echo    "|          cifrar : openssl enc -rc4 -e -K chave -in ficheiroCifrar  |"
    echo    "|                 -out ficheiroCifrado                               |"
    echo    "|          decifrar : openssl enc -rc4 -d -K chave -in               |"
    echo    "|                     ficheiroCifrado -out ficheiroDecifrado         |" 
    echo "   |                                                                    |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         |      AES - Advanced Encryption Standart       |          |"
    echo    "|          -----------------------------------------------           |"  
    echo    "|                                                                    |"
    echo    "|          Cifra de chave simétrica por blocos que aceita chaves     |"
    echo    "|           de cifra com 128(8 bytes), 192(12 bytes) ou              |"
    echo    "|           256 bits (16 bytes) e o tamanho do bloco é de            |"
    echo    "|           128 bits (16 bytes).                                     |"
    echo    "|                                                                    |"
    echo    "|          COMANDOS                                                  |"					 
    echo    "|           Cifrar : openssl enc -aes-128 -K chave -in ficheiroCifrar|"
    echo    "|                    -out ficheiroCifrado -iv 0                      |"	
    echo    "|           Decifrar : openssl enc -d -aes-128 -K chave              |"
    echo    "|                     -in ficheiroCifrado -out ficheiroDecifrado     |"
    echo    "|                                                                    |"				
	echo    "|          -----------------------------------------------           |"
	echo    "|         |                     Base 64                   |          |"
    echo    "|          -----------------------------------------------           |"  
    echo    "|                                                                    |" 
    echo    "|           Método para codificação de dados, é constituido por 64   |"
    echo    "|           caracteres ([A-Z],[a-z],[0-9],"/" e "+").                |"
    echo    "|                                                                    |"
    echo    "|          COMANDOS                                                  |"					 
    echo    "|           Cifrar : openssl enc -base64 -K chave -in                |"
    echo    "|                    ficheiroEntrada -out ficheiroSaida              |"	
    echo    "|           Decifrar : openssl enc -base64 -d -K chave -in           |"
    echo    "|                     ficheiroSaida -out ficheiroSaida               |"
    echo    "|                                                                    |"	
    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |" 
    echo    "|          Pequena descrição dos comandos apresentados em cima:      |"
    echo    "|                                                                    |"
    echo    "|           openssl : Biblioteca openssl                             |"
    echo    "|           enc : usado em cifras de chave simétricas para cifrar e  |"
    echo    "|                  decifrar                                          |"
    echo    "|           -d : decrypt                                             |"					 
    echo    "|           -K : parametro seguinte encontra-se em hexadecimal       |"
    echo    "|           -in : ficheiro de entrada                                |"	
    echo    "|           -out : ficheiro de saida                                 |"
    echo    "|           -iv : vetor de inicialização que é necessário nas cifras |"
    echo    "|           por blocos.                                              |"	
    echo    " --------------------------------------------------------------------"

	echo -n "1 para sair "; read option_help1                        
	echo "" 

	case $option_help1 in
		1) menu_help ;;
		*) echo "Opção Inválida!"
	esac				                    

}

funcoes_hash(){
	clear_screen
    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |"
    echo    "|                              AJUDA                                 |"
	echo    "|                                                                    |"
	echo    "|    -------------------------------------------------------------   |"
	echo    "|   |                     Funções de Hash                         |  |"
    echo    "|    -------------------------------------------------------------   |"
    echo    "|                                                                    |"
    echo    "|      Nesta seção do programa, será lhe possibilitada a utilização  |"
    echo    "|       de funções de hash.                                          |"
    echo    "|      Uma função de hash gera uma sequência de bits chamado hash.   |"
    echo    "|      O hash é representado em hexadecimal, ou seja, sequências de  |"
    echo    "|       bits constituido por letras e numeros de [0 a 9] e [A a F].  |"
    echo "   |                                                                    |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         |             MD5/4 - Message Digest            |          |"
    echo    "|          -----------------------------------------------           |"
    echo    "|                                                                    |"    
    echo    "|          Função de hash que produz resumos de 128 bits de          |"
    echo    "|           mensagens com tamanho máximo de 2^64 - 1 bits.           |"
    echo    "|                                                                    |"
    echo    "|         COMANDOS                                                   |"
    echo    "|          openssl dgst -md5/4 ficheiro                              |"
    echo "   |                                                                    |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         |          SHA1- Secure Hash Algorithm          |          |"
    echo    "|          -----------------------------------------------           |"  
    echo    "|                                                                    |"
    echo    "|          Função de hash que produz um resumo de 160 bits de        |"
    echo    "|           qualquer mensagem com tamanho máximo de 2^64 - 1 bits.   |"
    echo    "|          Existe também, SHA224/256/384/512, que usam um algoritmo  |"
    echo    "|           identico ao SHA1, mas oferecem a funcionalidade de       |"
    echo    "|           escolher o tamanho do resumo (224, 256, 384, 512 bits).  |"
    echo    "|                                                                    |"
    echo    "|          COMANDOS                                                  |"					 
    echo    "|           openssl dgst -sha1/224/256/384/512 ficheiro              |"
    echo    "|                    -out ficheiroCifrado -iv 0                      |"	
    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |" 
    echo    "|        Pequena descrição dos comandos apresentados em cima:        |"
    echo    "|                                                                    |"
    echo    "|           openssl : Biblioteca openssl                             |"
    echo    "|           dgst : digest                                            |"
    echo    " --------------------------------------------------------------------"

	echo -n "1 para sair "; read option_help2                        
	echo "" 

	case $option_help2 in
		1) menu_help ;;
		*) echo "Opção Inválida!"
	esac
}

chaves_RSA(){
	clear_screen
    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |"
    echo    "|                              AJUDA                                 |"
	echo    "|                                                                    |"
	echo    "|    -------------------------------------------------------------   |"
	echo    "|   |            Gerar chaves RSA - Rivest Shamir Adleman         |  |"
    echo    "|    -------------------------------------------------------------   |"
    echo    "|                                                                    |"
    echo    "|      Nesta seção do programa, será lhe possibilitada a geração     |"
    echo    "|        e manipulação de chaves RSA.                                |"
    echo "   |                                                                    |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         |             Gerar chaves RSA                 |           |"
    echo    "|          -----------------------------------------------           |"
    echo    "|                                                                    |" 
    echo    "|         COMANDOS                                                   |"   
    echo    "|          openssl genrsa -out ficheiroDeSaida 1024                  |"
    echo "   |                                                                    |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         |            Extrair a chave pública            |          |"
    echo    "|          -----------------------------------------------           |"  
    echo    "|                                                                    |"
    echo    "|         COMANDOS                                                   |"
    echo    "|          openssl rsa -in ficehiroComChaves -out ficheiroChavePub   |"
    echo    "|           -pubout                                                  |"
    echo    "|                                                                    |"				
    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |" 
    echo    "|          Pequena descrição dos comandos apresentados em cima:      |"
    echo    "|                                                                    |"
    echo    "|           openssl : Biblioteca openssl                             |"
    echo    "|           1024 : módulo em bits, ou sejao tamanho das chaves       |"
    echo    "|           -pubout : expecificar que queremos a chave pública       |"					 
    echo    "|           genrsa : gerar par de chaves                             |"
    echo    "|           rsa : manipular chaves RSA                               |"	
    echo    " --------------------------------------------------------------------"

	echo -n "1 para sair "; read option_help3                        
	echo "" 

	case $option_help3 in
		1) menu_help ;;
		*) echo "Opção Inválida!"
	esac

}

certificados_digitais(){
	clear_screen
    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |"
    echo    "|                              AJUDA                                 |"
	echo    "|                                                                    |"
	echo    "|    -------------------------------------------------------------   |"
	echo    "|   |                   Certificados Digitais                     |  |"
    echo    "|    -------------------------------------------------------------   |"
    echo    "|                                                                    |"
    echo    "|      Nesta seção do programa, será lhe possibilitada a utilização  |"
    echo    "|       de certificados digitais.                                    |"
    echo    "|      Certificado digital é um documento digital, este contém o     |"
    echo    "|       nome do propritário do certificado, contém uma data de inicio|"
    echo    "|       de validade e uma data de fim de validade. Este documento    |"
    echo    "|       terá também a chave pública do dono do mesmo, estará também  |"
    echo    "|       assinado digitalmente. Esta assinatura é gerada com a chave  |"
    echo    "|       privada.                                                     |"
    echo "   |                                                                    |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         |           Pedir Geração de Certificados       |          |"
    echo    "|          -----------------------------------------------           |"
    echo    "|                                                                    |"    
    echo    "|          Antes da criação do certificado é necessário fazer um     |"
    echo    "|           pedido, que será, depois usado na criação do certificado.|"
    echo    "|                                                                    |"
    echo    "|         COMANDOS                                                   |"
    echo    "|          openssl req -new -sha256 -key chavePrivada -out pedidoCer |"
    echo "   |                                                                    |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         |          Criar Certificados Digitais          |          |"
    echo    "|          -----------------------------------------------           |"  
    echo    "|                                                                    |"
    echo    "|          COMANDOS                                                  |"					 
    echo    "|           openssl x509 -trustout -signkey chavePrivada -days NDias |"
    echo    "|            -req -sha256 -in pedidoCer                              |"	
    echo    "|                                                                    |"
	echo    "|          -----------------------------------------------           |"
	echo    "|         |         Encadeamento de Certificados          |          |"
    echo    "|          -----------------------------------------------           |"  
    echo    "|                                                                    |"
    echo    "|          COMANDOS                                                  |" 
    echo    "|           openssl x509 -req -days NDias -in pedidoCer -CA nomeCer  |"
    echo    "|            -CAKey chavePrivada -set_serial Nserie -out nomeCer     |"
    echo    "|            -sha256                                                 |"
    echo    "|                                                                    |"
    echo    "|          -----------------------------------------------           |"
    echo    "|         |         Verificação de Certificados           |          |"
    echo    "|          -----------------------------------------------           |" 
    echo    "|                                                                    |"
    echo    "|          COMANDOS                                                  |"					 
    echo    "|           openssl verify -trusted nomeCertificados                 |"
    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |" 
    echo    "|          Pequena descrição dos comandos apresentados em cima:      |"
    echo    "|                                                                    |"
    echo    "|           openssl : Biblioteca openssl                             |"
    echo    "|           req :  faz o pedido do certificado                       |"
    echo    "|           -key : utiliza a chave privada que esta contida no       |"
    echo    "|                  ficheiro a seguir                                 |"					 
    echo    "|           -x509 : tipo de certificado                              |"
    echo    "|           -days : número de dias que o certificado é válido        |"	
    echo    "|           -CA : nome de uma certificado da Autoridade Certificadora|"
    echo    "|           -CAKey :  chave da Autoridade Certificadora              |"
    echo    "|           verify :  verifica uma mensagem assinada                 |"
    echo    "|           -trusted : verifica se o certificado esta é assinado     |"
    echo    "|                     digitalmente                                   |"	
    echo    " --------------------------------------------------------------------"

	echo -n "1 para sair "; read option_help4                       
	echo "" 

	case $option_help4 in
		1) menu_help ;;
		*) echo "Opção Inválida!"
	esac				                    


}

assinatura_digital(){
    clear_screen
    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |"
    echo    "|                              AJUDA                                 |"
    echo    "|                                                                    |"
    echo    "|    -------------------------------------------------------------   |"
    echo    "|   |                      Assinatura Digital                     |  |"
    echo    "|    -------------------------------------------------------------   |"
    echo    "|                                                                    |"
    echo    "|      Nesta seção do programa, será lhe possivel assinar            |"
    echo    "|        digitalmente ficheiros. Uma assinatura digital é um código  |"
    echo    "|        utilizado como forma de autenticação, é como se fosse uma   |"
    echo    "|        uma assinatura manual só muito mais segura.                 |"
    echo "   |                                                                    |"
    echo    "|          -----------------------------------------------           |"
    echo    "|         |           Criar assinaturas digitais         |           |"
    echo    "|          -----------------------------------------------           |"
    echo    "|                                                                    |"
    echo    "|         COMANDOS                                                   |"    
    echo    "|           openssl dgst -sha256                                     |"
    echo "   |                                                                    |"
    echo    "|          -----------------------------------------------           |"
    echo    "|         |          Calcular assinatura digital          |          |"
    echo    "|          -----------------------------------------------           |"  
    echo    "|                                                                    |"
    echo    "|         COMANDOS                                                   |"
    echo    "|          openssl dgst -sha256 ficheiroEntrada > hash.sha256        |"
    echo    "|                                                                    |"
    echo    "|          openssl rsault -sign -in hash.sha256 -out hash.sig -inkey |"
    echo    "|          parDeChaves.pem                                           |"
    echo    "|                                                                    |" 
    echo    "|          -----------------------------------------------           |"
    echo    "|         |          Verificar assinatura digital         |          |"
    echo    "|          -----------------------------------------------           |"  
    echo    "|                                                                    |"
    echo    "|         COMANDOS                                                   |"
    echo    "|          openssl rsault -verify -in ficheiroEntrada -out hash.hash |"
    echo    "|           -inkey parChaves -pubin                                  |"
    echo    "|                                                                    |"
    echo    "|          openssl dgst -sha256 ficheiroTexto > hash2.hash           |"
    echo    "|                                                                    |"
    echo    "|          diff ficheirosAComparar                                   |"
    echo    "|                                                                    |"               
    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |" 
    echo    "|          Pequena descrição dos comandos apresentados em cima:      |"
    echo    "|                                                                    |"
    echo    "|           openssl : Biblioteca openssl                             |"
    echo    "|           dgst : usado para calcular o hash de um ficheiro         |"
    echo    "|           rsault :  utilizado para cifrar e decifrar com RSA       |"                     
    echo    "|           diff : utilizador para comparar ficheiros                |"
    echo    "|           -inkey : expecifica que o ficheiro seguinte é um par de  |"
    echo    "|                    chaves RSA                                      |"
    echo    "|           -pubin : expecifica que queremos utilizar a chave pública|"
    echo    " --------------------------------------------------------------------"

    echo -n "1 para sair "; read option_help5                      
    echo "" 

    case $option_help5 in
        1) menu_help ;;
        *) echo "Opção Inválida!"
    esac

}

comparacao_ficheiros(){
    clear_screen
    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |"
    echo    "|                              AJUDA                                 |"
    echo    "|                                                                    |"
    echo    "|    -------------------------------------------------------------   |"
    echo    "|   |                    Comparar ficheiros                       |  |"
    echo    "|    -------------------------------------------------------------   |"
    echo    "|                                                                    |"
    echo    "|      Nesta seção do programa, será lhe possibilitada a comparação  |"
    echo    "|        de ficheiros.                                               |"
    echo    "|                                                                    |" 
    echo    "|         COMANDOS                                                   |"   
    echo    "|          diff ficheirosAComparar                                   |"
    echo "   |                                                                    |"
    echo    " --------------------------------------------------------------------"
    echo    "|                                                                    |" 
    echo    "|          Pequena descrição dos comandos apresentados em cima:      |"
    echo    "|                                                                    |"
    echo    "|           openssl : Biblioteca openssl                             |"
    echo    "|           diff : usado para comparar ficheiros                     |"
    echo    " --------------------------------------------------------------------"

    echo -n "1 para sair "; read option_help7                       
    echo "" 

    case $option_help7 in
        1) menu_help ;;
        *) echo "Opção Inválida!"
    esac

}




menu_Start # inicia a função para mostrar o menu principal no terminal
