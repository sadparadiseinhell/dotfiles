/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nobody";

static const char *colorname[NUMCOLS] = {
	[INIT]   =  "#20242c",   /* after initialization */
	[INPUT]  =  "#5E81AC",   /* during input */
	[FAILED] =  "#BF616A",   /* wrong password */
	[CAPS]   =  "#EBCB8B",   /* CapsLock on */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* default message */
static const char * message = "";

/* text color */
static const char * text_color = "#D8DEE9";

/* text size (must be a valid size) */
static const char * font_name = "-xos4-terminus-medium-r-normal--20-200-72-72-c-100-iso10646-1";

/* time in seconds before the monitor shuts down */
static const int monitortime = 600;
