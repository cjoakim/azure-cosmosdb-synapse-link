
# Copy the generated retail dataset zip file to the Xxx/data/ directories
# and unzip it there.
# Chris Joakim, Microsoft

zipfile="DatasetGeneration/data/retail/retail_dataset.zip"
basename="retail_dataset.zip"

echo '==='
echo 'creating data directories ...'
mkdir -p DotnetConsoleApp/data/
mkdir -p JavaConsoleApp/app/data/
mkdir -p PythonConsoleApp/data/

echo '==='
echo 'listing zipfile contents ...'
jar tvf $zipfile

echo '==='
echo 'copying zip file to target ConsoleApp directories ...'
cp $zipfile DotnetConsoleApp/data/
cp $zipfile JavaConsoleApp/app/data/
cp $zipfile PythonConsoleApp/data/

echo '==='
echo 'unzipping in DotnetConsoleApp ...'
cd DotnetConsoleApp/data/
unzip -o $basename
pwd
ls -al
cd ../..

echo '==='
echo 'unzipping in JavaConsoleApp ...'
cd JavaConsoleApp/app/data/
unzip -o $basename
pwd
ls -al
cd ../../..

echo '==='
echo 'unzipping in PythonConsoleApp ...'
cd PythonConsoleApp/data/
unzip -o $basename
pwd
ls -al
cd ../..
 
echo 'done'
