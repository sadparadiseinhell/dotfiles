/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nobody";

static const char *colorname[NUMCOLS] = {
    [INIT]   = "#20242c",   /* after initialization */
    [INPUT]  = "#5E81AC",   /* during input */
    [FAILED] = "#BF616A",   /* wrong password */
    [CAPS]   = "#EBCB8B",   /* CapsLock on */
};

/* Xresources preferences to load at startup */
ResourcePref resources[] = {
    { "init",   STRING,  &colorname[INIT]   },
    { "input",  STRING,  &colorname[INPUT]  },
    { "failed", STRING,  &colorname[FAILED] },
    { "caps",   STRING,  &colorname[CAPS]   },
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear   = 1;

/* time in seconds before the monitor shuts down */
static const int monitortime   = 600;
