# autozim (bkm) 🤖

The purpose of this tool/script is to automate the process of using zimit/browsertrix/webcrawler to download content. Created for educational/archival/EC purposes only.

- automatically convert bookmarks in folder/bkm.txt
- downloads websites listed in ./bkm.txt (using docker desktop) - (image: browsertrix-webcrawler)
- prepares the downloaded WARCs to be converted into zimfiles
- execute these commands to convert multiple compressed folders/WARCs to usable format_file.zim (Kiwix, etc...)
- output a simple_file.zim and then cleans the directory if the conversion if successful
- cleans docker env before proceeding to download the next website
- reiterate until all ./bkm.txt is peeled
- enjoy
- Special thanks goes to: OpenZIM team, StackExchange teams and Reddit contributors/users.
- Don't be shy to fork/contribute to this project! Help is welcome.

UPDATE 1 - 
added code fixes/updates to the exclude filter
added backup of docker images in case of (???)
added excludeList folder, (tba) will add list you can choose from to speed up archival
adding more support for multiple keyword exclude filters 

- Supports "UPDATING" of each .zim file once in the "# ZIM Files" folder, will add support for more in a future update.
- * May crash/fail if more than 1 of the filename.zim/filename_UPDATED.zim are in the ZIM folder.
- * Best practice: use a clean folder everytime.
![start](https://github.com/user-attachments/assets/cccddfce-8bf9-41c2-8fae-977bd5141747)

![end](https://github.com/user-attachments/assets/8341d002-353d-4bed-945e-1eaeeb6cdb92)
