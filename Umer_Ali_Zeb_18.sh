#!/bin/bash

function usage() {
cat <<EOF	
	Usage: ${0} [-drac] USER [USERN] 
	Disable a local Linux account. 
	-d  Borra las cuentas  desabilitandolas. 
	-r Borra el directorio principal asociado con la cuenta. 
	-a Crear un archivo de directorio asociado con la cuenta.
	-u Deshabilita al usuario pero estas no se borran.
EOF
exit 1
}

if [[ "${UID}" -ne 0 ]]
then
 	echo 'Es necesario ejecutar el scrip como administrador'
   	exit 1
fi

if [ $# -eq 0 ]; then
	usage
fi

while getopts ":d:r:a:u:" OPT
do
  case ${OPTº} in
    d)
      USER="${OPTARG}"
      userdel ${USER}
      if [ $? -eq 0 ]; then
        echo "Se eliminó el usuario: ${USER}"
      else
		echo "No se ha podido eliminar el usuario"
      fi
      ;;
      
    r)
 	USER="${OPTARG}"
      	rm -r /home/${USER}
      	if [ $? -eq 0 ]; then
        	echo "Se ha eliminado el Home : ${USER} "
      	else
		echo "No se ha  eliminar el Home del usuario"
      	fi
      	;;
      
    a)
    	USER="${OPTARG}"
	cp -r /home/${USER} /var/Umer/${USER}.copia
	if [ $? -eq 0 ]; then
        	echo "La copia de seguridad realizada correctamente: ${USER}"
      	else
		echo "No se ha podido realizar la copia"
      	fi
      	;;
      
    u)
    	USER="${OPTARG}"
      	usermod -L ${USER}
      	if [ $? -eq 0 ]; then
        	echo "Ha sido deshabilitado el usuario: ${USER} "
      	else
		echo "No se ha podido deshabilitar el usuario"
      	fi
      	;;
      
    \?)
	echo "ERROR: Invalid option -$OPTARG"
	usage
	;;
    :)
	echo "ERROR: -$OPTARG requires an argument."
	;;
    *)
	echo "Unknown error."
	usage
	;;
  esac
done

shift "$(( OPTIND - 1 ))"

if [ -z "${USER}" ]; then
	usage
fi
