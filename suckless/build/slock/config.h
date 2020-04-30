/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nobody";

static const char *colorname[NUMCOLS] = {
	[INIT]   = "black",     /* after initialization */
	[INPUT]  = "#005577",   /* during input */
	[FAILED] = "#CC3333",   /* wrong password */
	[CAPS]   = "red",       /* CapsLock on */
};

/*
 * Xresources preferences to load at startup
 */
ResourcePref resources[] = {
    { "init",   STRING,  &colorname[INIT]   },
    { "input",  STRING,  &colorname[INPUT]  },
    { "failed", STRING,  &colorname[FAILED] },
    { "caps",   STRING,  &colorname[CAPS]   },
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;


/* time in seconds before the monitor shuts down */
static const int monitortime = 60;



/* time in seconds to cancel lock with mouse movement */
static const int timetocancel = 0;
