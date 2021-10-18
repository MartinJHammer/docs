# WSL Cypress Guide
*MAIN GUIDE*
https://nickymeuleman.netlify.app/blog/gui-on-wsl2-cypress

*XServer*
https://sourceforge.net/projects/vcxsrv/

*If asked about password (sudo) all the time in WSL*
https://askubuntu.com/questions/21343/how-to-make-sudo-remember-my-password-and-how-to-add-an-application-to-startup

*General XServer / WSL GUI guide*
https://itnext.io/using-windows-10-as-a-desktop-environment-for-linux-7b2d8239f2f1

*Firewall troubleshooting*
https://stackoverflow.com/questions/61860208/wsl-2-run-graphical-linux-desktop-applications-from-windows-10-bash-shell-erro
https://stackoverflow.com/questions/60304251/unable-to-open-x-display-when-trying-to-run-google-chrome-on-centos-rhel-7-5

## Ensure cypress.json has the following
  "env": {
    "tsConfig": "tsconfig.json"
  }

## set DISPLAY variable to the IP automatically assigned to WSL2 in .bashrc
export DISPLAY=$(ip route | grep default | awk '{print $3}'):0
sudo /etc/init.d/dbus start &> /dev/null


