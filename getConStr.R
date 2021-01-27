library("data.table")
library("rlist")

##################################################################
# getConnectionString
#
# configName - see below, but w/o square brackets
# filePath   - full path to file
# sepParam   - parameters separator
#
# if nothing found will return blank string
# creates connection string from parameters written in config file
# with given structire:
# ----------------------------------------------------------------
# [configName1]
# param1: value1
# param2: value2
# param3: value3
#
# [configName2]
# param4: value4
# param5: value5
# param6: value6
#
# etc.
# ----------------------------------------------------------------
##################################################################

getConnectionString <- function(configName, filePath, sepParam) {
    getIt <- 0
    conStr <- ""
    strNum <- 0
    config <- fread(filePath, sep = ":", fill = TRUE, header= FALSE) # blank.lines.skip = TRUE,
    configName <- paste('[', configName, ']', sep ='')

    for (i in 1:nrow(config)) {
        str_row = toString(config[i])
        if (str_row == configName & getIt != 1) {
            getIt <- 1
            strNum <- i
        }
        if (str_row == '') {
            getIt <- 0
        }
        if (getIt == 1 & i > strNum) {
            row <- strsplit(str_row, ": ")[[1]]
            paramValue <- paste(row[1],row[2], sep = '=')
            conStr <- paste(conStr, paramValue, sepParam, sep = '')
        }
    }
    return(conStr)
}