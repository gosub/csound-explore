import csnd6

params = """
sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1
"""

player = """
instr 99
	Sample = p4
	Sdir = "/home/gg/downloads/samples/sums/step/"
	a1 diskin strcat(Sdir, strcat(Sample, "01.wav"))
	out a1, a1
endin
"""

cycle = """
instr 1
  icycle = p4
  ; beats
{0}
  ; temporal recursion
  schedule 1, 1, 1, (icycle+1)
  turnoff
endin
"""

cs = csnd6.Csound()
th = None

def start():
    global th
    cs.SetOption("-odac")
    cs.SetMessageLevel(0)
    cs.CompileOrc(params)
    cs.CompileOrc(player)
    cs.Start()
    th = csnd6.CsoundPerformanceThread(cs)
    th.Play()
    cs.CompileOrc(cycle.format(""))
    cs.CompileOrc("schedule 1,0,1,0")

def stop():
    cs.Stop()
    cs.Cleanup()
    exit()

def recycle(s=""):
    if isinstance(s, str):
        cs.CompileOrc(cycle.format(s))
    elif isinstance(s, list):
        cs.CompileOrc(cycle.format(pat2sch(s)))


# pattern modifiers

def scale(sc, pattern):
    p2 = []
    for sound in pattern:
        s2 = dict(sound)
        s2["start"] *= sc
        s2["end"] *= sc
        p2.append(s2)
    return p2

def trans(t, pattern):
    p2 = []
    for sound in pattern:
        s2 = dict(sound)
        s2["start"] += t
        s2["end"] += t
        p2.append(s2)
    return p2

def equi(*patterns):
    l = len(patterns)
    step = 1.0/l
    ps = []
    for i, pattern in enumerate(patterns):
        ps.append(trans(i*step, scale(step, pattern)))
    return sorted(sum(ps,[]), key=lambda s: s['start'])

def par(*patterns):
    return sorted(sum(patterns,[]), key=lambda s: s['start'])

def snd(smpl, start=0.0, end=1.0):
    return [{'sample': smpl, 'start': start, 'end': end}]

def snd2sch(snd, instr=99):
    tmplt = "schedule {instr},{start},{dur},\"{smpl}\"" 
    return tmplt.format(instr=instr,
                        start = snd['start'],
                        dur = 1,
                        smpl = snd['sample'])

def pat2sch(pattern):
    return "\n".join(snd2sch(snd) for snd in pattern)

