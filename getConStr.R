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

read_file <- function(file_path) {
    config <- fread(
        file_path,
        sep = ":",
        fill = TRUE,
        # blank.lines.skip = TRUE,
        header = FALSE
    )
    return(config)
}

get_rows_from_config <- function(config, config_name, separator) {
    get_it <- 0
    con_str <- ""
    str_num <- 0

    for (i in 1:nrow(config)) {
        str_row <- toString(config[i])
        if (str_row == config_name & get_it != 1) {
            get_it <- 1
            str_num <- i
        }
        if (str_row == "") {
            get_it <- 0
        }
        if (get_it == 1 & i > str_num) {
            row <- strsplit(str_row, ": ")[[1]]
            param_values <- paste(row[1], row[2], sep = "=")
            con_str <- paste(con_str, param_values, separator, sep = "")
        }
    }
    return(con_str)
}

getConnectionString <- function(config_name, file_path, separator) {
    config <- read_file(file_path)
    config_name <- paste("[", config_name, "]", sep = "")
    result <- get_rows_from_config(
        config = config,
        config_name = config_name,
        separator = separator
    )
    return(result)
}

get_urllike_connection <- function(
        config_name,
        file_path,
        separator,
        config_type
    ) {
    config <- read_file(file_path)
    config_name <- paste("[", config_name, "]", sep = "")
    connection_parameters <- get_rows_from_config(
        config = config,
        config_name = config_name,
        separator = separator
    )
    list_of_connection_parameters <- as.list(
        strsplit(connection_parameters, ",")[[1]]
    )

    params <- vector(mode = "list")
    for (i in 1:length(list_of_connection_parameters)) {
        list_elem <- strsplit(list_of_connection_parameters[[i]], "=")[[1]]
        params[[list_elem[1]]] <- list_elem[2]
    }

    if (config_type == "mongodb") {
        connection_string <- paste(
            "mongodb://",
            params$user, ":",
            params$password, "@",
            params$host, ":",
            params$port,
            "/?authsource=", params$authsource,
            "&ssl=", params$ssl,
            sep = ""
        )
    } else {
        connection_string <- ""
    }
    return(connection_string)
}