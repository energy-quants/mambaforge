set -euox pipefail


stdout=$(podman run -it --rm localhost/mambaforge mamba --version)
exitcode=$?
echo "${stdout}"

# check exitcode
if [ $exitcode -ne 0 ]; then
    exit $exitcode
fi

# check expected output
lines=($stdout)
if [[ "${lines[0]}" != "mamba" ]]; then
    exit 1
fi
if [[ "${lines[2]}" != "conda" ]]; then
    exit 1
fi
