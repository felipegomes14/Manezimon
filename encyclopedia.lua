local encyclopedia = {}

encyclopedia.open = false
encyclopedia.selected = 1

encyclopedia.entries = {

    {
        id = "martim_pescador",
        name = "MARTIM PESCADOR",
        type = "fire",
        seen = true,
        description =
            "Uma ave territorial que aquece o próprio corpo com energia vulcânica. Seus mergulhos deixam rastros de fogo no ar.",
        sprite = "sprites/creatures/martim_pescador/catalogo.png"
    },

    {
        id = "ra_manezinha",
        name = "RÃ MANEZINHA",
        type = "grass",
        seen = false,
        description =
            "Criatura rara encontrada em áreas úmidas da ilha. Seu canto acelera o crescimento das plantas ao redor.",
        sprite = "sprites/creatures/ra_manezinha/catalogo.png"
    },

    {
        id = "catanhao",
        name = "CATANHÃO",
        type = "water",
        seen = false,
        description =
            "Predador aquático extremamente resistente. Seu casco absorve impactos e libera jatos de água pressurizada.",
        sprite = "sprites/creatures/catanhao/catalogo.png"
    },
    {
        id = "maruim",
        name = "MARUIM",
        type = "normal",
        seen = false,
        description =
            "Inseto irritante que se alimenta de sangue. Suas picadas causam coceira intensa e podem transmitir doenças.",
        sprite = "sprites/creatures/maruim/catalogo.png"
    },
    {
        id = "tainha",
        name = "TAINHA",
        type = "water",
        seen = false,
        description =
            "Peixe migratório que percorre longas distâncias. Sua carne é apreciada por pescadores locais.",
        sprite = "sprites/creatures/tainha/catalogo.png"
    }


}

-- ================= LOAD IMAGES =================
function encyclopedia.load()

    for _,v in ipairs(encyclopedia.entries) do
        v.image = love.graphics.newImage(v.sprite)
    end
end

-- ================= REGISTER =================
function encyclopedia.register(id)

    for _,v in ipairs(encyclopedia.entries) do
        if v.id == id then
            v.seen = true
            return
        end
    end
end

-- ================= COUNT =================
function encyclopedia.countSeen()

    local total = 0

    for _,v in ipairs(encyclopedia.entries) do
        if v.seen then
            total = total + 1
        end
    end

    return total
end

return encyclopedia