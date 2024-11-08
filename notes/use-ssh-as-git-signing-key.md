# Use the SSH key you configured for GitHub authentication as a signing key

SSH signature verification is available in Git 2.34 or later.

## Tell GitHub about your signing key 

- You already have an SSH key that you use to authenticate with GitHub. We need to add the same key as a signing key so GitHub can verify your SSH commit signatures.
- View your GitHub keys: https://github.com/settings/keys
- Click "New SSH Key" to add a new key
- Call it something nice
- Select "Signing Key" as the Key Type
- Paste in the public key:
```
cat ~/.ssh/id_ed25519.pub | pbcopy
```
  
## Sign commits with your SSH key

- Tell Git you want to sign with SSH:
```
git config --global gpg.format ssh
``` 
- Tell Git which key to use as the signing key:
```
tmpkey=$(cat ~/.ssh/id_ed25519.pub)
git config --global user.signingKey $tmpkey
unset tmpkey
```
- The `-S` option asks Git to sign the commit:
```
git commit -S -m 'This commit is signed'
```
- But that's tedious. Let's tell Git to sign all commits by default:
```
git config --global commit.gpgsign true
```

## Enable Git to verify commit signatures

If you `--show-signature` with `git log`, Git will not be able to verify the SSH signature on the commit. To fix:
- Create a file of "allowed signers"
```
mkdir -p ~/.config/git
touch ~/.config/git/allowed_signers
```
- Add your email and the public key:
```
echo "jason@jason.com $(cat ~/.ssh/id_ed25519.pub)" > ~/.config/git/allowed_signers
```
- Tell Git about this file:
```
git config --global gpg.ssh.allowedSignersFile "~/.config/git/allowed_signers"
```

## More info

For more info and actual explanations see: https://blog.dbrgn.ch/2021/11/16/git-ssh-signatures/