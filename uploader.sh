

echo "Add the pcks to include on export into the build folder"

rm seattle_freeze.zip
#rm build/*
#rm build/minigames/*
# godot runner here.

mkdir build/minigames/
cp minigames/*.pck build/minigames/

zip seattle_freeze.zip build/* build/minigames/*

echo "Do the manual pck export..."

#cd build/
#echo "View at: http://localhost:8000/index.html"
#python -m http.server .
