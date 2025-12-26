## Memo

IDA: 
	- **use <tab> to see assembly from pseudo -code** => could help for debugging with gef (`vmmap` : entrypoint +IDA offset)
	- IDA Offset: **Options -> General -> Line prefixes : get offsets**
	- `.rodata` : data initialised :copy/paste
	- `.data` : non initialised -> reverse
	- https://malwareunicorn.org/workshops/idacheatsheet.html


GTK code: callbacks (functions as handlers)
Openssl/Routines: 
	- https://linux.die.net/man/3/evp_encryptinit 
	- `int EVP_EncryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type, ENGINE *impl, unsigned char *key, unsigned char *iv);` => key/iv 
	- `int EVP_DecryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out, int *outl, unsigned char *in, int inl);` => buffer out
	- https://docs.openssl.org/3.0/man3/OPENSSL_init_crypto/
