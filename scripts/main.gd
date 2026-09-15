extends Node2D

var phase := "intro"
var time := 0.0
var player_name := ""
var input_box: LineEdit
var dialogue_index := 0
var train_x := 0.0
var snow := []
var memory := []
var suspects := ["ياسر النجار", "فهد الكيلاني", "نادين منصور", "كريم حداد", "سليم الراوي", "هالة مراد"]

func _ready():
    randomize()
    for i in range(180):
        snow.append(Vector2(randf_range(0, 1280), randf_range(0, 720)))
    queue_redraw()

func _process(delta):
    time += delta
    if phase == "train":
        train_x += delta * 90.0
        if train_x > 80: train_x = 0
    queue_redraw()

func _input(event):
    if event is InputEventMouseButton and event.pressed:
        _click(event.position)
    elif event is InputEventScreenTouch and event.pressed:
        _click(event.position)

func _click(p: Vector2):
    if phase == "intro":
        if Rect2(470, 555, 340, 70).has_point(p):
            _show_name()
    elif phase == "name":
        if Rect2(470, 555, 340, 70).has_point(p):
            player_name = input_box.text.strip_edges()
            if player_name == "": player_name = "المحقق"
            input_box.queue_free()
            _add_memory("02:17", "مكالمة غامضة", "وصل اتصال ليلي من ياسر النجار يطلب المساعدة.")
            phase = "call"
            dialogue_index = 0
    elif phase == "call":
        if Rect2(1000, 610, 210, 65).has_point(p):
            dialogue_index += 1
            if dialogue_index >= 4:
                _add_memory("02:19", "تحذير", "قال ياسر إنه يعتقد أن شخصًا ما يريد قتله.")
                phase = "journey"
            queue_redraw()
    elif phase == "journey":
        if Rect2(1000, 610, 210, 65).has_point(p):
            phase = "train"
            dialogue_index = 0
            _add_memory("اليوم التالي", "الدعوة", "اتفق المحقق مع ياسر على اللقاء في محطة القطار والسفر لحضور زفاف أخيه.")
            queue_redraw()
    elif phase == "train":
        if Rect2(25, 25, 180, 58).has_point(p):
            phase = "memory"
        elif Rect2(1020, 610, 210, 65).has_point(p):
            phase = "train_dialogue"
            dialogue_index = 0
        queue_redraw()
    elif phase == "train_dialogue":
        if Rect2(1000, 610, 210, 65).has_point(p):
            dialogue_index += 1
            if dialogue_index >= 5:
                _add_memory("21:43", "حديث عابر", "قال ياسر: سنتحدث عن الأمر بعد الوصول. لم يعرف المحقق أن هذه ستكون آخر مرة يراه فيها حيًا.")
                phase = "explore"
            queue_redraw()
    elif phase == "explore":
        if Rect2(25, 25, 180, 58).has_point(p):
            phase = "memory"
        elif Rect2(1030, 575, 200, 70).has_point(p):
            _add_memory("23:08", "توقف القطار", "توقف القطار بسبب الثلوج الكثيفة في منطقة جبلية نائية.")
            phase = "crime"
        queue_redraw()
    elif phase == "crime":
        if Rect2(25, 25, 180, 58).has_point(p):
            phase = "memory"
        elif Rect2(1010, 600, 220, 65).has_point(p):
            phase = "memory"
        queue_redraw()
    elif phase == "memory":
        if Rect2(1020, 610, 210, 65).has_point(p):
            phase = "train" if dialogue_index == 0 else "crime"
        queue_redraw()

func _show_name():
    phase = "name"
    input_box = LineEdit.new()
    input_box.position = Vector2(470, 455)
    input_box.size = Vector2(340, 60)
    input_box.placeholder_text = "اكتب اسم المحقق"
    input_box.alignment = HORIZONTAL_ALIGNMENT_CENTER
    input_box.add_theme_font_size_override("font_size", 26)
    add_child(input_box)
    input_box.grab_focus()
    queue_redraw()

func _add_memory(t, title, body):
    memory.append({"time":t, "title":title, "body":body})

func _draw():
    draw_rect(Rect2(0,0,1280,720), Color("#10131d"))
    if phase in ["intro","name","call"]:
        _draw_bedroom()
    elif phase == "journey":
        _draw_station()
    elif phase in ["train","train_dialogue"]:
        _draw_train()
    elif phase == "explore":
        _draw_exploration()
    elif phase == "crime":
        _draw_crime()
    elif phase == "memory":
        _draw_memory()
    if phase != "memory" and phase != "name":
        _draw_memory_button()

func _font():
    return ThemeDB.fallback_font

func _text(s, pos, size=24, color=Color.WHITE, align=HORIZONTAL_ALIGNMENT_LEFT):
    draw_string(_font(), pos, s, align, -1, size, color)

func _center(s, y, size=30, color=Color.WHITE):
    _text(s, Vector2(640,y), size, color, HORIZONTAL_ALIGNMENT_CENTER)

func _button(rect, label):
    draw_style_box(_box(Color("#22293a"), Color("#6d7690"), 2, 12), rect)
    _text(label, Vector2(rect.position.x, rect.position.y+42), 23, Color("#f1eee7"), HORIZONTAL_ALIGNMENT_CENTER)

func _box(bg, border, width, radius):
    var b = StyleBoxFlat.new()
    b.bg_color=bg; b.border_color=border
    b.set_border_width_all(width); b.set_corner_radius_all(radius)
    return b

func _draw_bedroom():
    draw_rect(Rect2(0,420,1280,300), Color("#171b27"))
    draw_rect(Rect2(760,120,300,300), Color("#22283a"))
    draw_rect(Rect2(800,160,220,120), Color("#343b50"))
    draw_rect(Rect2(40,100,360,300), Color("#1d2332"))
    draw_line(Vector2(40,400), Vector2(1240,400), Color("#5c5360"), 3)
    # lamp
    draw_circle(Vector2(630,210), 55, Color("#d6a85b"))
    draw_line(Vector2(630,265), Vector2(630,390), Color("#8a765a"), 8)
    draw_circle(Vector2(630,210), 24, Color("#f5d58b"))
    # bed
    draw_rect(Rect2(100,470,500,145), Color("#293246"))
    draw_rect(Rect2(80,430,540,80), Color("#3b455b"))
    draw_circle(Vector2(155,470), 40, Color("#d8d2c6"))
    _center("ملفات الظل", 80, 34, Color("#e7c98a"))
    if phase == "intro":
        _center("الساعة 02:17 صباحًا", 330, 28, Color("#b8bdca"))
        _center("الهاتف يرن...", 370, 24, Color("#e7e2d8"))
        _button(Rect2(470,555,340,70),"الرد على الاتصال")
    elif phase == "name":
        _center("قبل أن تبدأ الرحلة...", 340, 30)
        _center("كيف يُسجّل اسم المحقق؟", 395, 25, Color("#bfc4d2"))
        _button(Rect2(470,555,340,70),"متابعة")
    else:
        _draw_dialogue_box()

func _draw_dialogue_box():
    draw_style_box(_box(Color("#181d29"),Color("#5d667b"),2,14),Rect2(90,455,1100,170))
    var lines = [
        ["ياسر النجار","آسف على الاتصال بهذا الوقت... كنت آخر شخص فكرت أن أتصل به."],
        [player_name,"مارتن؟ هل تعرف كم الساعة؟"],
        ["ياسر النجار","أعرف. لكن ما عندي وقت. أعتقد أن أحدهم يريد قتلي."],
        [player_name,"قل لي كل شيء، وسأقابلك غدًا."]
    ]
    var d = min(dialogue_index, lines.size()-1)
    _text(lines[d][0],Vector2(1120,500),22,Color("#d8b56e"),HORIZONTAL_ALIGNMENT_RIGHT)
    _text(lines[d][1],Vector2(1120,545),24,Color("#f0eee9"),HORIZONTAL_ALIGNMENT_RIGHT)
    _button(Rect2(1000,610,210,65),"التالي")

func _draw_station():
    draw_rect(Rect2(0,0,1280,460),Color("#202535"))
    draw_rect(Rect2(0,460,1280,260),Color("#11151e"))
    for i in range(10):
        draw_line(Vector2(i*150,470),Vector2(i*150+80,720),Color("#3d3540"),5)
    for i in range(80):
        var x = fmod(i*83 + time*25,1280.0)
        var y = 50 + fmod(i*47,390.0)
        draw_circle(Vector2(x,y),2,Color("#dfe7f2"))
    draw_rect(Rect2(70,90,1140,100),Color("#171b28"))
    _center("محطة الشمال — ليلة شتوية", 155, 34, Color("#e6c989"))
    # train
    draw_rect(Rect2(120,330,1040,145),Color("#343b4d"))
    for i in range(6):
        draw_rect(Rect2(165+i*155,350,110,75),Color("#121723"))
        draw_rect(Rect2(180+i*155,362,80,50),Color("#8a7e68"))
    _center("القطار 47", 530, 30)
    _center("الموعد: 21:00", 570, 23, Color("#b8bdca"))
    _button(Rect2(1000,610,210,65),"صعود القطار")

func _draw_train():
    draw_rect(Rect2(0,0,1280,720),Color("#141824"))
    # windows
    for i in range(7):
        draw_rect(Rect2(55+i*175,80,130,260),Color("#263044"))
        draw_rect(Rect2(65+i*175,90,110,240),Color("#0b111c"))
        for s in range(12):
            var sx = 70+i*175+fmod(s*37+time*80,100)
            var sy = 105+fmod(s*53,215)
            draw_circle(Vector2(sx,sy),1.5,Color("#cdd8e7"))
    draw_rect(Rect2(0,340,1280,380),Color("#302c2d"))
    draw_rect(Rect2(0,340,1280,20),Color("#9d8052"))
    # table
    draw_rect(Rect2(450,455,380,150),Color("#573f32"))
    draw_circle(Vector2(640,440),50,Color("#e2c78e"))
    _center("قطار 47", 55, 30, Color("#e7c98a"))
    _center("رحلة الشتاء", 390, 25, Color("#b8bdca"))
    _text("الذاكرة",Vector2(52,65),20,Color("#f1eee7"),HORIZONTAL_ALIGNMENT_CENTER)
    _button(Rect2(1020,610,210,65),"التحدث مع ياسر")

func _draw_exploration():
    draw_rect(Rect2(0,0,1280,720),Color("#151923"))
    draw_rect(Rect2(0,0,1280,110),Color("#1e2433"))
    _center("القطار متوقف",65,32,Color("#e6c989"))
    _center("أمامك حرية استكشاف العربات والتحدث مع الركاب.",100,20,Color("#b8bdca"))
    var labels=["عربة المطعم","ممر النوم","مقصورة ياسر","المقصورة 7","عربة الخدمة"]
    for i in range(5):
        var r=Rect2(80+i*240,250,200,105)
        draw_style_box(_box(Color("#242b3b"),Color("#697389"),2,12),r)
        _text(labels[i],Vector2(r.position.x,r.position.y+62),22,Color("#eee9df"),HORIZONTAL_ALIGNMENT_CENTER)
    _center("الثلج يزداد خارج النوافذ...",480,23,Color("#c6cad5"))
    _button(Rect2(1030,575,200,70),"انتظر قليلًا")

func _draw_crime():
    draw_rect(Rect2(0,0,1280,720),Color("#0d1018"))
    draw_rect(Rect2(0,0,1280,100),Color("#1b2030"))
    _center("القضية 001",45,24,Color("#b9bdc9"))
    _center("الرحلة الأخيرة",85,38,Color("#e3c27e"))
    # compartment
    draw_rect(Rect2(120,145,1040,450),Color("#2a2d36"))
    draw_rect(Rect2(175,190,390,300),Color("#191d27"))
    draw_rect(Rect2(700,190,360,300),Color("#191d27"))
    # body silhouette, non-graphic
    draw_ellipse(Vector2(880,390),Vector2(105,55),Color("#343b49"))
    draw_circle(Vector2(800,355),28,Color("#343b49"))
    draw_rect(Rect2(845,350,160,55),Color("#343b49"))
    draw_line(Vector2(190,520),Vector2(1070,520),Color("#6d5747"),4)
    _center("الباب كان مغلقًا...",555,24,Color("#d4d7df"))
    _center("والقاتل ما زال على متن القطار.",595,26,Color("#e1b86f"))
    _button(Rect2(1010,600,220,65),"ابدأ التحقيق")

func draw_ellipse(center:Vector2, radius:Vector2, color:Color):
    var pts=PackedVector2Array()
    for i in range(40):
        var a=TAU*i/40.0
        pts.append(center+Vector2(cos(a)*radius.x,sin(a)*radius.y))
    draw_colored_polygon(pts,color)

func _draw_memory():
    draw_rect(Rect2(0,0,1280,720),Color("#10131d"))
    draw_rect(Rect2(0,0,1280,105),Color("#1e2433"))
    _center("🧠 الذاكرة",65,36,Color("#e6c989"))
    _text("كل ما اكتشفته أثناء الرحلة يبقى محفوظًا.",Vector2(640,125),21,Color("#bfc4d2"),HORIZONTAL_ALIGNMENT_CENTER)
    var y=165
    if memory.is_empty():
        _center("لا توجد معلومات بعد.",300,25,Color("#9ea5b5"))
    else:
        for m in memory:
            draw_style_box(_box(Color("#1b2130"),Color("#4f596f"),1,10),Rect2(100,y,1080,78))
            _text(m.time,Vector2(1120,y+30),18,Color("#d7b875"),HORIZONTAL_ALIGNMENT_RIGHT)
            _text(m.title,Vector2(1120,y+57),22,Color("#f1eee8"),HORIZONTAL_ALIGNMENT_RIGHT)
            _text(m.body,Vector2(1070,y+48),19,Color("#bfc4d2"),HORIZONTAL_ALIGNMENT_RIGHT)
            y+=92
    _button(Rect2(1020,610,210,65),"العودة")

func _draw_memory_button():
    draw_style_box(_box(Color("#22293a"),Color("#6d7690"),2,10),Rect2(25,25,180,58))
    _text("🧠 الذاكرة",Vector2(25,62),20,Color("#f1eee7"),HORIZONTAL_ALIGNMENT_CENTER)
