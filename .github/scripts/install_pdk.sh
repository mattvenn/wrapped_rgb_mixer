cd $HOME
git clone https://github.com/efabless/caravel_user_project.git

cd caravel_user_project
git checkout $USER_PROJECT_COMMIT

make install
cd caravel
git checkout $CARAVEL_COMMIT
cd ..

make pdk
make openlane
