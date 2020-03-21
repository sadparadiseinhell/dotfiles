/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nobody";

static const char *colorname[NUMCOLS] = {
	[INIT]   =  "#030303",     /* after initialization */
	[INPUT]  =  "#295E73",   /* during input */
	[FAILED] =  "#C45C5C",   /* wrong password */
	[CAPS]   =  "#5D3270",         /* CapsLock on */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* time in seconds before the monitor shuts down */
static const int monitortime = 600;
