# WSL Setup

## Steps to setup WSL (Windows + Linux combo)
3. Install WSL (Windows Subsystem for Linux): https://docs.microsoft.com/en-us/windows/wsl/install-win10
4. Install Docker Desktop for Windows: https://www.docker.com/products/docker-desktop - Also see:
    - https://docs.docker.com/docker-for-windows/install/
    - https://docs.docker.com/desktop/faqs/
5. Ensure Docker Desktop has integration enabled for your Linux version: Settings -> Resources -> WSL INTEGRATION. Ensure your Ubuntu version is ticked off.
6. Install VS Code + `Remote - WSL extension`. You can now open VS code in the linux/ubuntu terminal via `code .`.

7. Setup nameserver for Ubuntu (prevents "Temporary failure in name resolution" message).
8. Ensure your Ubuntu has all the needed development tools installed and updated.
    - Update Ubuntu: `sudo apt update` and `sudo apt -y upgrade`.
    - Run: `sudo apt-get install build-essential`
    - Python version must be 3.8.5. Run `python`. If it does not return 3.8.5 or higher, see:
        > sudo apt purge -y python2.7-minimal // remove other versions
        > Confirm the new version of Python: python --version
    - nvm (node version manager) is installed: https://github.com/nvm-sh/nvm#installing-and-updating.
    - Install better-npm-run: `npm i -g better-npm-run`.
    - Ensure the correct version of node is installed and used:
       `$ nvm list` // See used
       `$ cd ~/.nvm/versions/node;ls` // All installed versions
       `$ sudo rm -rf v4.2.3/` // Remove version
    - Generate ssh key to use with gitlab
        > `ssh-keygen -t ed25519 -C "credentials-gitlab"`
        > `cat ~/.ssh/id_ed25519.pub` -> Copy output into gitlab: gitlab.com -> ssh keys -> Add key.
    - Go to the coms project and run `nvm use` to use the correct node version. This can be done for all projects, but should not be necessary to do more than once.
10. Remove packge-lock.json from all of them, as it can result in `ENOENT: no such file or directory` errors.
12. Run `npm i` in each project. Observe the input - there should be no build errors. Note: it will log a lot of "Deprecated" packages, and show vulnurbilaties at the end. This is expected. If you get errors, see the "Debugging" section.
13. In the coms project, you can try to run `npm start`. Open another terminal for the frontend project and run `npm start` there as well. You might have to run two terminals for the coms project. One where you run `docker-compose up ...` FIRST, and then another for `npm start`.
14. You should now see the ui login screen at localhost:4200/login

## Debugging
- nvm does not use the correct version
    > See https://stackoverflow.com/questions/24585261/nvm-keeps-forgetting-node-in-new-terminal-session
    > Check `node -v`. Default should be 12.15 (as of writing this).
    > `nvm list` -> You should only have one node version installed. Chan`nvm` Use `nvm uninstall x.xx.x` to uninstall unwanted versions. Remember to x
- Docker/Linux returns `No permission`.
    - Ensuring Docker Desktop (settings -> resources -> WSL integration) allows the Linux dist you are using. 
    - Try to run: `sudo docker-compose up -d`. Not working? Continue...
    - Restart docker and wsl:
        - Close docker in windows.
        - In admin Powershell terminal: `wsl --terminate Ubuntu-20.04` then `wsl --shutdown`. Note the Ubuntu version must match yours installed.
- Docker/Linux returns `File not found`.
    - Ensuring all steps here are followed: https://docs.docker.com/docker-for-windows/install/.
    - Enable Hyper-V: https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
- `npm i` is EXTREMELY slow = You're Linux nameserver is not setup correctly. See above guide + https://github.com/microsoft/WSL/issues/5256#issuecomment-666545999
    - It is strongly recommended to do the above steps from the terminal.
    - Success: You can ping google: `$ ping www.google.com`
- `npm i` and/or `npm start` show a lot of `gyp ERR! build error` messages = You're python version is not up to date.
- `npm i` return `ENOENT: no such file or directory` = Remove package-lock.json.
- `Starting inspector on 0.0.0.0:9252 failed: address already in use. app chrashed (address already in use).` message while trying to run `npm start` in any of the following: coms2api, coms2oauth, token-service, user-service = You need to restart WSL. Removing the coms container from Docker Desktop might also work. Remember you need to restart WSL first, and also close docker, then open Ubuntu, then open Docker desktop, or you might not have the docker compose command.
- `auth/login` on portal doesn't work? Install Redirectly (Rule: Replace string https -> http).
- localhost:4200/login returns `504: Error occured while trying to proxy to: localhost:4200/api/company/e/public` = one of the other projects (coms. coms2api, coms2oauth, token-service, user-service) are chrashing/not setup correctly.
- npm cannot find packages = Login to npm via `npm login`. Note your npm user needs access to your organization.
- Localhost ERR_CONNECTIN_REFUSED = Disable windows fast start up (google it) -> Shutdown WSL `wsl --shutdown` -> Restart.
    > Also see: https://stackoverflow.com/questions/63452108/get-err-connection-refused-accessing-django-running-on-wsl2-from-windows-but-can

## Nice to know
- MongoDB, postgress, etc. is a part of the Docker image - no need to install.
- If you code . ubuntu
- You can see your ubuntu files in windows in the following path: `\\wsl$\Ubuntu-<version>\home\<user-name>`
    - Example: `\\wsl$\Ubuntu-20.04\home\mjhammer`
    - Note: These are NOT the same file system you see in the terminal!  (Have Martin Petersen explain this).