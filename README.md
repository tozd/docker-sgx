A Docker image with [Intel SGX](https://software.intel.com/en-us/sgx) [SDK and
PSW](https://github.com/01org/linux-sgx) (platform software, i.e., runtime).
You can use it as a base Docker image for your apps which use Intel SGX.

Intel SGX [kernel module](https://github.com/01org/linux-sgx-driver) has to be loaded on the
host and you have to provide it to the container when you run it:

```
docker run -i -t --rm --device=/dev/isgx tozd/sgx:ubuntu-trusty bash
```
