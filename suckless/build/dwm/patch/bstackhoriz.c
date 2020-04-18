static void
bstackhoriz(Monitor *m)
{
	unsigned int i, n;
	int mx = 0, my = 0, mh = 0, mw = 0;
	int sx = 0, sy = 0, sh = 0, sw = 0;
	float mfacts, sfacts;
	int mrest, srest;
	Client *c;

	int oh, ov, ih, iv;
	getgaps(m, &oh, &ov, &ih, &iv, &n);

	if (n == 0)
		return;

	sx = mx = m->wx + ov;
	sy = my = m->wy + oh;
	mh = m->wh - 2*oh;
	sh = m->wh - 2*oh - ih * (n - m->nmaster - 1);
	mw = m->ww - 2*ov - iv * (MIN(n, m->nmaster) - 1);
	sw = m->ww - 2*ov;

	if (m->nmaster && n > m->nmaster) {
		sh = (mh - ih) * (1 - m->mfact);
		mh = (mh - ih) * m->mfact;
		sy = my + mh + ih;
		sh = m->wh - mh - 2*oh - ih * (n - m->nmaster);
	}

	getfacts(m, mw, sh, &mfacts, &sfacts, &mrest, &srest);

	for (i = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), i++) {
		if (i < m->nmaster) {
			resize(c, mx, my, (mw / mfacts) + (i < mrest ? 1 : 0) - (2*c->bw), mh - (2*c->bw), 0);
			mx += WIDTH(c) + iv;
		} else {
			resize(c, sx, sy, sw - (2*c->bw), (sh / sfacts) + ((i - m->nmaster) < srest ? 1 : 0) - (2*c->bw), 0);
			sy += HEIGHT(c) + ih;
		}
	}
}
