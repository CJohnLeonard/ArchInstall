#Deleting pacman cache
#sudo pacman -Sc

#Deleting Yay cache 
#yay -Sc

#Deletes all packages in the cache wether they are installed or not installed in the system
#it's all the same with yay

#sudo pacman -Scc
#yay -Scc

#cleaning up all unwanted dependencies
# yay -Yc

#checking orphan packages 
#pacman -Qtdq
#to remove orphan packages
#sudo pacman -Rns $(pacman -Qtdq)
#or
# su
# cd
# pacman -Qdtq | pacman -Rns

# to find out how much space the .cache directy
#du -sh .cache/
# Removing .cache directory
# the * basicaly tells that you want to delete everythig inside the directory and not the directory itself
# rm -rf .cache/*

#to find out how much space the .config/ directy
#du -sh .config/
# Removing .config/ directory
# the * basicaly tells that you want to delete everythig inside the directory and not the directory itself
# rm -rf .config/*
 
# to find out how much space the journal directy
#du -sh //var/log/journal/
#  to remove journal directory
# sudo journalctl --vacuum-time=2weeks
