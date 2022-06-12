#!bin/sh
#Compare yeasts genomes with funannotate
#Rodolfo Angeles, june 2022

#add salple prefix in the .gbk
for smpl in $(cat list2fun.txt); do
        cd ../out/$smpl/annotate_results
        sed -i 's/FUN_/$smpl/g' *.gbk
        cd ../..
done
#
mkdir fun_yeasts.compare ../res/
#funannotate compare
#caution!
#this script will compare all annotate_results
#placed in the `../out/` dir
funannotate compare \
-i ../out/*/annotate_results/*.gbk \
-o fun_yeasts.compare \
--run_dnds estimate \
--cpus 55

mv fun_yeasts.* ../res/
#END
