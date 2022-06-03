cd crash-dialog
echo "Building crash dialog..."
lime build mac
cp build/openfl/mac/bin/CrashDialog ../export/release/mac/bin/J64E-CrashDialog
cd ..
