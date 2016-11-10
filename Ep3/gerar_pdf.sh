#!/bin/bash

echo "Gerando relatório dos resultados em PDF";

path_resultados="$PWD/Resultados";
path_PDF="$HOME/PDF";

rm $path_PDF/*.pdf

## Imprime as figuras em arquivos .pdf

ls $path_resultados/*.jpg | while read ARQ	
do
	echo "$ARQ"
	lp -d PDF -o orientation-requested=3 $ARQ
done

output_pdf="ep3_marcos.pdf"
temp_pdf="temp.pdf"
capa_pdf="ep3.pdf"


if [ -e $temp_pdf ]; then
	rm $temp_pdf
fi

if [ -e $output_pdf ]; then
	rm $output_pdf
fi

sleep 10

## Junta os pdf em um único arquivo

ls $path_PDF/*.pdf | while read ARQ	
do
	echo $ARQ
	if [ ! -e $output_pdf ]; then
		pdftk $ARQ output $output_pdf
		cp $output_pdf $temp_pdf
	else
		pdftk $temp_pdf $ARQ output $output_pdf
		rm $temp_pdf
		cp $output_pdf $temp_pdf
	fi
done

pdftk $capa_pdf $temp_pdf output $output_pdf

rm $temp_pdf



