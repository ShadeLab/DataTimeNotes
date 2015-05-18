To transfer files to the HPCC from the metabolomics core:

You will need the following information for the metabolomics core server:
username, password, host name

It's a good idea to first open an ftp session to the metabolomics core server and find your data. That way you know the file path to your data which you will need in a moment. 

Log on to the HPCC. If you will be transferring a lot of the files, use one of the low usage nodes. If you are only going to transfer a few files, it is ok to stay in the gateway.
Navigate into the folder where you would like to transfer the files.

Use the following command:
```
wget -r --user=[put username here] --password=[put password here] ftp://[server name here]/[path to your data]
```
Note: you CAN use * as a wildcard here to transfer multiple files.
You should see a progress bar and it will take up to several minutes to transfer the files. 

This way of transferring them will create a lot of nested folders in your destination path. There is a way to do this more cleanly but we weren't able to figure out how to do it on 5/14/15.
