for i in {0..99}
do
	python Sparcc.py Resamplings/boot_$i.txt -i 10 --cor_file=Bootstraps/sim_cor_$i.txt >> sparcc.log
done
