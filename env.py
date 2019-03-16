# coding:utf-8
import Tkinter, os

# 實例視窗
window = Tkinter.Tk()
# 視窗標題
window.title("Core Docker")
# 視窗大小
# window.geometry("320x600")

# projectPort frame
projectPort = Tkinter.Frame(window)

lscommand = os.popen('ls "./project"').read()
list = lscommand.split("\n")
listLen =  len(list)-1
del list[listLen]
del list[0]
projectFrame = {}
for idx, project in enumerate(list):
    # 生成 燈號
    Tkinter.Label(projectPort, text="●", fg="red").grid(row=idx, column=0, sticky=Tkinter.W)
    # 生成 project label
    Tkinter.Label(projectPort, text=project).grid(row=idx, column=2, sticky=Tkinter.W)
    # 生成 project button
    projectButton = Tkinter.Button(projectPort, text="啟動")
    projectButton.grid(row=idx, column=3)
projectPort.grid(row=0, column=0)

# textAreaPort frame
textAreaPort = Tkinter.Text(window)
teTkinter.Text(textAreaPort).place(x=0, y=0, anchor='nw').tag_config("here", background="black", foreground="green")
teTkinter.Text(textAreaPort).place(x=0, y=0, anchor='nw')
textAreaPort.grid(row=0, column=1, sticky=Tkinter.N)

window.mainloop()