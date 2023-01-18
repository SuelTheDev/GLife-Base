---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Dylan Malandain.
--- DateTime: 29/08/2019 00:08
---

CurrentSession = {
    username =nil,
    password = nil,
    perms = {}
}
CurrentComputer = nil
RMenu.Add('computer', 'main', RageUI.CreateMenu(nil, "Actions disponibles",10,200))
RMenu.Add('computer', 'login', RageUI.CreateSubMenu(RMenu:Get('computer', 'main'),"", "Se connecter"))
RMenu.Add('computer', 'register', RageUI.CreateSubMenu(RMenu:Get('computer', 'main'),"", "Nouveau compte"))

RMenu.Add('computer', 'logged', RageUI.CreateMenu(nil, "Actions disponibles",10,200))
RMenu.Add('computer', 'mail', RageUI.CreateSubMenu(RMenu:Get('computer', 'logged'),"", "Actions disponibles"))
RMenu.Add('computer', 'send_mail', RageUI.CreateSubMenu(RMenu:Get('computer', 'mail'),"", "Envoyer un mail"))
RMenu.Add('computer', 'list_mail', RageUI.CreateSubMenu(RMenu:Get('computer', 'mail'),"", "Messages disponibles"))
RMenu.Add('computer', 'manage_mail', RageUI.CreateSubMenu(RMenu:Get('computer', 'list_mail'),"", "Actions disponibles"))
RMenu.Add('computer', 'settings', RageUI.CreateSubMenu(RMenu:Get('computer', 'logged'),"", "Paramètres disponibles"))

RMenu.Add('computer', 'criminal_records', RageUI.CreateSubMenu(RMenu:Get('computer', 'logged'),"", "Casiers judiciaire"))
RMenu.Add('computer', 'gestion_cam', RageUI.CreateSubMenu(RMenu:Get('computer', 'logged'),"", "Caméras disponibles"))


RMenu:Get('computer', 'gestion_cam').Closed = function()
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    ClearTimecycleModifier("scanline_cam_cheap")
    SetFocusEntity(GetPlayerPed(PlayerId()))
    ResetrOldI()
end
RMenu.Add('computer', 'job_gestion', RageUI.CreateSubMenu(RMenu:Get('computer', 'logged'),"", "Gestion entreprise"))
RMenu.Add('computer', 'job_gestion_permission', RageUI.CreateSubMenu(RMenu:Get('computer', 'job_gestion'),"", "Gestion des permissions"))
RMenu.Add('computer', 'job_gestion_permission_add', RageUI.CreateSubMenu(RMenu:Get('computer', 'job_gestion'),"", "Gestion des permissions"))

RMenu.Add('computer', 'job_gestion_workers', RageUI.CreateSubMenu(RMenu:Get('computer', 'job_gestion'),"", "Employés"))
RMenu.Add('computer', 'job_gestion_workers_gerer', RageUI.CreateSubMenu(RMenu:Get('computer', 'job_gestion_workers'),"", "Gestion employé"))

IndexMessage = nil
SendMail = {
    message = nil,
    auteur = nil
}


RMenu:Get('computer', 'job_gestion_workers'):AddInstructionButton({
    [1] = GetControlInstructionalButton(1, 315, 0),
    [2] = "Promouvoir",
})

RMenu:Get('computer', 'job_gestion_workers'):AddInstructionButton({
    [1] = GetControlInstructionalButton(1, 314, 0),
    [2] = "Rétrograder",
})



local ComputerPerms = {
    police = {
        {label = "Promouvoir un employé",name="promote_worker_police"},
        {label = "Rétrograder un employé",name="demote_worker_police"},
        {label = "Viré un employé",name="fire_worker_police"},
        {label = "Supprimer un casier",name="remove_casier"},
        {label = "Ajouter un casier",name="add_casier"},
        {label = "Accès casier",name="casier"},
        {label = "Cameras LSPD",name="gestion_cam_LSPD01"},
        {label = "Modifier permissions",name="edit_perm_police"},
    }
}

Hacking = false
local CurrentWorker = 0
function RefreshMail()
    TriggerServerCallback('mail:GetMessage', function(data)
        CurrentSession.mail = data
        
    end,CurrentSession.username.."@RainLayer City.com")
end
Citizen.CreateThread(function()
    while true do
        Wait(1)
        if RageUI.Visible(RMenu:Get('computer', 'main')) then
            RageUI.DrawContent({ header = false, glare = false }, function()
                RageUI.Button("Se connecter",nil,{},true,function(_,_,Selected)

                end,RMenu:Get('computer', 'login'))

                RageUI.Button("Créer un compte",nil,{},true,function(_,_,Selected)

                end,RMenu:Get('computer', 'register'))

                if Hacking then
                    RageUI.Button("~r~K~s~ali Linux",nil,{},true,function(_,_,Selected)

                    end)
                end
            end, function()
            end)
        end
        
        if RageUI.Visible(RMenu:Get('computer', 'login')) then
            RageUI.DrawContent({ header = false, glare = false }, function()
                RageUI.Button("Nom d'utilisateur",nil,{RightLabel = CurrentSession.username},true,function(_,_,Selected)
                    if Selected then
                        CurrentSession.username = KeyboardInput("Entrez votre nom d'utilisateur","",30)
                    end
                end)

                RageUI.Button("Mot de passe",nil,{RightLabel =CurrentSession.password2},true,function(_,_,Selected)
                    if Selected then
                        CurrentSession.password = KeyboardInput("Entrez votre mot de passe","",30)
                        CurrentSession.password2 = ""
                        for i = 1 , string.len(CurrentSession.password),1 do
                            CurrentSession.password2 = CurrentSession.password2.."•"
                        end
                    end
                end)

                RageUI.Button("",nil,{},true,function(_,Active,Selected)
                    if Active then
                        if RageUI.CurrentMenu.Controls.Up.Pressed then
                            RMenu:Get('computer', 'login').Index = 2
                        else
                            RMenu:Get('computer', 'login').Index = 4
                        end
                    end
                end)

                RageUI.Button("Se connecter",nil,{},true,function(_,_,Selected)
                    if Selected then
                        TriggerServerCallback('computer:Login', function(valid,data)
                            if valid then
                                CurrentSession.Connected = true
                                if data ~= nil then
                                    CurrentSession.perms = json.decode(data)
                                end
                                RageUI.GoBack()
                                Wait(5)
                                RageUI.GoBack()
                                Wait(5)
                                RageUI.Visible(RMenu:Get('computer', 'logged'),true)
                            else
                                RageUI.Popup({message="~r~Nom d'utilisateur/mot de passe incorrect"})
                            end
                        end,CurrentSession)
                    end
                end)
            end, function()
            end)
        end

        if RageUI.Visible(RMenu:Get('computer', 'register')) then
            RageUI.DrawContent({ header = false, glare = false }, function()
                RageUI.Button("Nom d'utilisateur",nil,{RightLabel = CurrentSession.username},true,function(_,_,Selected)
                    if Selected then
                        CurrentSession.username = KeyboardInput("Entrez votre nom d'utilisateur","",30)
                    end
                end)

                RageUI.Button("Mot de passe","Ne mettez pas un mot de passe que vous utilisez ailleurs ",{RightLabel = CurrentSession.password2},true,function(_,_,Selected)
                    if Selected then
                        CurrentSession.password = KeyboardInput("Entrez votre mot de passe","",30)
                        CurrentSession.password2 = ""
                        for i = 1 , string.len(CurrentSession.password),1 do
                            CurrentSession.password2 = CurrentSession.password2.."•"
                        end
                    end
                end)
                RageUI.Button("",nil,{},true,function(_,Active,Selected)
                    if Active then
                        if RageUI.CurrentMenu.Controls.Up.Pressed then
                            RMenu:Get('computer', 'register').Index = 2
                        else
                            RMenu:Get('computer', 'register').Index = 4
                        end
                    end
                end)
                RageUI.Button("S'inscrire",nil,{},true,function(_,_,Selected)
                    if Selected and CurrentSession.username ~= nil and CurrentSession.username ~= ""  then
                        TriggerServerCallback('computer:Register', function(valid)
                            if valid then
                                CurrentSession.Connected = true
                                RageUI.Visible(RMenu:Get('computer', 'register'),false)

                                RageUI.Visible(RMenu:Get('computer', 'logged'),true)
                            else
                                RageUI.Popup({message="~r~Nom d'utilisateur déjà utilisé !"})
                            end
                        end,CurrentSession)
                    end
                end)
            end, function()
            end)
        end

        --- qd on est connecté
        if RageUI.Visible(RMenu:Get('computer', 'logged')) then
            RageUI.DrawContent({ header = false, glare = false }, function()
                RageUI.Button("Boite mail",nil,{},true,function(_,_,Selected)
                    if Selected then
                        RefreshMail()
                    end
                end,RMenu:Get('computer', 'mail'))
                RageUI.Button("Paramètre du compte",nil,{},true,function(_,_,Selected)

                end,RMenu:Get('computer', 'settings'))

                if CurrentComputer ~= nil and CurrentComputer.Buttons then
                    for i = 1 ,#CurrentComputer.Buttons,1 do
                        RageUI.Button(CurrentComputer.Buttons[i].label,nil,{},true,function(_,_,Selected)
                            if Selected then
                                CurrentComputer.Buttons[i].fct()
                            end
                        end,RMenu:Get('computer',CurrentComputer.Buttons[i].submenu))
                    end
                end
                if Job:IsBoss() or isPermTo("gestion_employ_"..Job:Get().name) then
                    RageUI.Button("Gestion de l'entreprise",nil,{},true,function(_,_,Selected)

                    end,RMenu:Get('computer', 'job_gestion'))
                end
                RageUI.Button("~r~Se déconnecter",nil,{},true,function(_,_,Selected)
                    if Selected then
                        CurrentSession = {}
                        RageUI.Visible(RMenu:Get('computer', 'logged'),false)
                    end
                end,RMenu:Get('computer', 'main'))


            end, function()
            end)
        end

        if RageUI.Visible(RMenu:Get('computer', 'settings')) then
            RageUI.DrawContent({ header = false, glare = false }, function()
                RageUI.Button("~r~Supprimer le compte","~r~IRRÉVERSIBLE",{},true,function(_,_,Selected)
                    if Selected then
                        TriggerServerEvent("computer:DeleteAccount",CurrentSession.username)
                        CurrentSession = {}
                        RageUI.Visible(RMenu:Get('computer', 'settings'),false)
                    end
                end,RMenu:Get('computer', 'main'))
            end, function()
            end)
        end
        if RageUI.Visible(RMenu:Get('computer', 'job_gestion')) then
            RageUI.DrawContent({ header = false, glare = false }, function()
                RageUI.Button("Gestion des employés",nil,{},true,function(_,_,Selected)
                    if Selected then
                        TriggerServerCallback('job:GetAllWorkers', function(data)
                            CurrentSession.workers = data
                        end,Job:Get().name)
                    end
                end,RMenu:Get('computer', 'job_gestion_workers'))
                if isPermTo("edit_perm_"..Job:Get().name) or Job:IsBoss() then
                    RageUI.Button("Gestion des permissions",nil,{},true,function(_,_,Selected)
                        if Selected then

                        end
                    end,RMenu:Get('computer', 'job_gestion_permission'))
                end
            end, function()
            end)
        end
        if RageUI.Visible(RMenu:Get('computer', 'job_gestion_permission')) then
            RageUI.DrawContent({ header = false, glare = false }, function()
                if CurrentSession.PermsToAdd == nil then 
                    CurrentSession.userPerms = tostring(KeyboardInput("Nom d'utilisateur de la personne",nil,50)) 
                    TriggerServerCallback('computer:GetPerms', function(data)
                        if data == nil then return end 
                        CurrentSession.PermsToAdd = json.decode(data)
                    end,CurrentSession.userPerms)
                    Wait(200)
                elseif CurrentSession.PermsToAdd ~= nil and #CurrentSession.PermsToAdd ~= 0 then
                    for i = 1 , #ComputerPerms[Job:Get().name],1 do
                        for x = 1,#CurrentSession.PermsToAdd,1 do
                            if CurrentSession.PermsToAdd[x] == ComputerPerms[Job:Get().name][i].name then
                                ComputerPerms[Job:Get().name][i].bool = CurrentSession.PermsToAdd[x] == ComputerPerms[Job:Get().name][i].name
                            end
                        end
                        RageUI.Checkbox(ComputerPerms[Job:Get().name][i].label,nil, ComputerPerms[Job:Get().name][i].bool,{},function(Hovered,Ative,Selected,Checked)
                            ComputerPerms[Job:Get().name][i].bool = Checked
                            if Selected then
                                if Checked then
                                    table.insert( CurrentSession.PermsToAdd, ComputerPerms[Job:Get().name][i].name  )
                                else
                                    for x = 1,#CurrentSession.PermsToAdd,1 do
                                        if CurrentSession.PermsToAdd[x] == ComputerPerms[Job:Get().name][i].name then
                                            table.remove( CurrentSession.PermsToAdd,x)
                                            break
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    RageUI.Button("~g~Sauvegarder",nil,{},true,function(_,_,Selected)
                        if Selected then
                            TriggerServerEvent("computer:SavePerms",CurrentSession.userPerms,CurrentSession.PermsToAdd)
                            CurrentSession.PermsToAdd = nil
                        end
                    end,RMenu:Get('computer', 'job_gestion'))
                end


            end, function()
            end)
        end

        if RageUI.Visible(RMenu:Get('computer', 'job_gestion_workers')) then
            RageUI.DrawContent({ header = false, glare = false }, function()
                if CurrentSession.workers ~= nil and tablelength(CurrentSession.workers) ~= 0 then
                    for i = 1 , tablelength(CurrentSession.workers),1 do
                        if CurrentSession.workers[i] ~= nil then
                            RageUI.Button(CurrentSession.workers[i].first_name .. " " .. CurrentSession.workers[i].last_name,nil ,{RightLabel=Jobs[CurrentSession.workers[i].job].grade[CurrentSession.workers[i].grade].label},true,function(_,Active,Selected)
                                if Active then
                                    if IsControlJustReleased(0,314) then
                                        if isPermTo("promote_worker_"..Job:Get().name) or Job:IsBoss() then
                                            if CurrentSession.workers[i].grade + 1 < Job:Get().gradenum then
                                                CurrentSession.workers[i].grade = CurrentSession.workers[i].grade +1 
                                                TriggerServerEvent("job:UpdateGrade",CurrentSession.workers[i].uuid,CurrentSession.workers[i].grade,Job:Get().label2,Job:Get().gradelabel)
                                            end
                                        else
                                            RageUI.Popup({message="~r~Vous n'avez pas la permission de faire ceci"})
                                        end
                                    end
                                    if IsControlJustReleased(0,315) then
                                        if isPermTo("demote_worker_"..Job:Get().name) or Job:IsBoss()then
                                            if CurrentSession.workers[i].grade == 1 then
                                                if isPermTo("fire_worker_"..ob:Get().name)  or Job:IsBoss() then
                                                    local valid = KeyboardInput("Virer? (~g~OUI ~s~ou ~r~NON~s~)",nil,50)
                                                    if valid == "OUI" then
                                                        TriggerServerEvent("job:Fire",CurrentSession.workers[i].uuid)
                                                        table.remove( CurrentSession.workers, i )
                                                    end
                                                else
                                                    RageUI.Popup({message="~r~Vous n'avez pas la permission de faire ceci"})
                                                end
                                            else
                                                CurrentSession.workers[i].grade = CurrentSession.workers[i].grade - 1 
                                                TriggerServerEvent("job:UpdateGrade",CurrentSession.workers[i].uuid,CurrentSession.workers[i].grade,Job:Get().label2,Jobs[Job:Get().name].grade[CurrentSession.workers[i].grade].label)
                                            end
                                        else
                                            RageUI.Popup({message="~r~Vous n'avez pas la permission de faire ceci"})
                                        end
                                    end

                                    if IsControlJustReleased(0,319) then
                                        local salaire = KeyboardInput("Nouveau salaire (ancien :"..CurrentSession.workers[i].salary.."$)","",30)
                                        if tonumber(salaire) ~= nil then
                                            CurrentSession.workers[i].salary= salaire
                                            TriggerServerEvent("job:UpdateSalaire",CurrentSession.workers[i].uuid,CurrentSession.workers[i].salary)
                                        end
                                        
                                    end
                                end
                            end)
                        end
                       
                    

                    end
                else
                    RageUI.Button("Vide",nil,{},true,function(_,_,Selected)
                    end)
                end
            end, function()
            end)
        end
    end
end)

function AddHackButton()
    Hacking = true
end
function AddPoliceSection()
    Lspd = true
end
function ToggelComputerMenu(m,computer)
    CurrentComputer = computer
    if CurrentSession.Connected and m then
        
        RageUI.Visible(RMenu:Get('computer', 'logged'),not RageUI.Visible(RMenu:Get('personnal', 'logged')))
    elseif m then

        RageUI.Visible(RMenu:Get('computer', 'main'),not RageUI.Visible(RMenu:Get('personnal', 'main')))
    else
        CurrentSession = {
            username ="21",
            password ="12",
            perms = {}
        }
        Hacking = false
        Lspd = false
        RageUI.Visible(RMenu:Get('computer', 'main'),not RageUI.Visible(RMenu:Get('personnal', 'main')))
    end
end


-- idée hack
-- * Keylogger
-- * Intercepteur du mail
-- * accès a distance
-- * pc lspd & ems -> plus dur