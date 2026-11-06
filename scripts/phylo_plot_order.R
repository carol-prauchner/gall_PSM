rm(list = ls())
library(ape)
library(geiger)
library(phytools)
library(diversitree)

############################################################
# 1. Dados e árvore
############################################################
setwd("/Users/carol/Documents/gall_PSM_paper")
database_data <- read.csv("gall_psm_final.csv", sep = ",", header = TRUE)

No_of_PSMs <- rowSums(database_data[, 3:5])
pmg2 <- cbind(database_data, No_of_PSMs)

texto1 <- textreadr::read_doc("/Users/carol/Documents/gall_PSM_paper/jse12086-sm-0003-suppapp-s3.doc")
arvore <- read.tree(text = texto1)
arvore1 <- keep.tip(arvore, tip = database_data$Families_of_seed_plant)
arvore1$node.label <- NULL

rownames(pmg2) <- pmg2$Families_of_seed_plant
name.check(arvore1, pmg2)
pmg2[is.na(pmg2)] <- 0

############################################################
# 2. Matrizes de caracteres e cores
############################################################
trait_data1 <- data.frame(
  "Lepidoptera" = as.numeric(pmg2$Lepidoptera),
  "Coleoptera"  = as.numeric(pmg2$Coleoptera),
  "Hymenoptera" = as.numeric(pmg2$Hymenoptera),
  "Hemiptera"   = as.numeric(pmg2$Hemiptera),
  "Diptera"     = as.numeric(pmg2$Diptera),
  "All Galls"   = as.numeric(pmg2$Gall),
  check.names = FALSE
)
rownames(trait_data1) <- pmg2$Families_of_seed_plant

cols1 = list("Lepidoptera" = c("#FFFFE0", "goldenrod2"),
            "Coleoptera"  = c("thistle2", "deeppink3"),
            "Hymenoptera" = c("gray91", "dimgray"),
            "Hemiptera"   = c("lightcyan2", "cyan3"),
            "Diptera"     = c("plum1", "purple"),
            "All Galls"   = c("lightyellow", "orange"))

trait_data <- data.frame(
  "Flavonoids"     = as.numeric(pmg2$Flavonoids),
  "Tannins"        = as.numeric(pmg2$Tannins),
  "Phenolic Acids" = as.numeric(pmg2$Phenolic_acids),
  "Gall Insects"   = as.numeric(pmg2$Gall),
  check.names = FALSE
)
rownames(trait_data) <- pmg2$Families_of_seed_plant

cols = list("Flavonoids"     = c("pink", "red"),
             "Tannins"        = c("lightblue", "blue"),
             "Phenolic Acids" = c("lightgreen", "darkgreen"),
             "Gall Insects"   = c("lightyellow", "orange"))

############################################################
# 3. Parâmetros da figura 
############################################################
LARG_FIG     <- 10     # largura da figura (polegadas)
ALT_FIG      <- 19     # altura da figura (polegadas)
PROP_LEGENDA <- 0.18   # fração da largura ocupada pela coluna de legendas
CEX_TIPS     <- 0.55   # tamanho dos nomes das famílias
FONTE_TIPS   <- 3      # 3 = itálico, 1 = normal
LARGURA_ANEL <- 0.045  # espessura de cada anel (fração da altura da árvore)
GAP_ARVORE   <- 0.02   # espaço entre as pontas da árvore e o 1º anel
LARG_RAMO    <- 0.6    # espessura dos ramos
CEX_LEGENDA  <- 1.2
ROTULOS      <- c("Absent", "Present")  # rótulos para 0 e 1

############################################################
# 4. Funções de desenho
############################################################
# Árvore circular + anéis de caracteres, desenhada "à mão" com ape
# para que a árvore ocupe todo o painel.
desenhar_arvore <- function(tree, dat, cols, letra) {
  par(mar = c(0, 0, 0, 0))
  ntip <- Ntip(tree)
  n    <- length(cols)
  
  # altura da árvore e raios dos anéis (unidades da árvore)
  H     <- max(node.depth.edgelength(tree))
  larg  <- H * LARGURA_ANEL
  r_in  <- H * (1 + GAP_ARVORE)
  r_out <- r_in + n * larg
  r_lab <- r_out + H * 0.015
  
  # espaço necessário para os nomes (estimativa em polegadas)
  din      <- par("din")
  painel   <- min(din[1] * (1 - PROP_LEGENDA), din[2] / 2)
  lab_in   <- max(nchar(tree$tip.label)) * 0.55 * CEX_TIPS * par("ps") / 72
  s        <- lab_in / painel
  lim      <- r_lab / (1 - 2 * s) * 1.02
  
  plot.phylo(tree, type = "fan", show.tip.label = FALSE,
             use.edge.length = TRUE, no.margin = TRUE,
             x.lim = c(-lim, lim), y.lim = c(-lim, lim),
             edge.width = LARG_RAMO)
  
  pp  <- get("last_plot.phylo", envir = .PlotPhyloEnv)
  xt  <- pp$xx[1:ntip]; yt <- pp$yy[1:ntip]
  ang <- atan2(yt, xt)
  rt  <- sqrt(xt^2 + yt^2)
  
  # linha pontilhada ligando pontas curtas aos anéis (árvore não ultramétrica)
  curta <- rt < r_in - 0.01 * H
  if (any(curta))
    segments(xt[curta], yt[curta], r_in * cos(ang[curta]), r_in * sin(ang[curta]),
             lty = 3, col = "grey60", lwd = 0.5)
  
  # anéis
  dth <- 2 * pi / ntip
  cunha <- function(a, r0, r1, col) {
    t <- seq(a - dth / 2, a + dth / 2, length.out = 8)
    polygon(c(r0 * cos(t), r1 * cos(rev(t))),
            c(r0 * sin(t), r1 * sin(rev(t))),
            col = col, border = col, lwd = 0.2)
  }
  for (j in seq_len(n)) {
    v  <- dat[tree$tip.label, names(cols)[j]]
    cc <- ifelse(!is.na(v) & v > 0, cols[[j]][2], cols[[j]][1])
    r0 <- r_in + (j - 1) * larg
    r1 <- r0 + larg * 0.88
    for (i in seq_len(ntip)) cunha(ang[i], r0, r1, cc[i])
  }
  
  # nomes das famílias, girados para ficarem legíveis
  deg  <- ang * 180 / pi
  vira <- cos(ang) < 0
  for (i in seq_len(ntip)) {
    text(r_lab * cos(ang[i]), r_lab * sin(ang[i]), tree$tip.label[i],
         srt = if (vira[i]) deg[i] + 180 else deg[i],
         adj = if (vira[i]) c(1, 0.5) else c(0, 0.5),
         cex = CEX_TIPS, font = FONTE_TIPS, xpd = NA)
  }
  
  mtext(letra, side = 3, adj = 0.01, line = -2, font = 2, cex = 2)
}

# Legenda em painel próprio
desenhar_legenda <- function(cols, rotulos = ROTULOS, cex = CEX_LEGENDA) {
  par(mar = c(0, 0, 0, 0))
  plot.new()
  plot.window(xlim = c(0, 1), ylim = c(0, 1))
  y <- 0.80
  for (nm in names(cols)) {
    lg <- legend(x = 0, y = y, legend = rotulos, fill = cols[[nm]],
                 title = nm, title.font = 2, title.adj = 0,
                 bty = "n", cex = cex, xpd = NA)
    y <- lg$rect$top - lg$rect$h - 0.01
  }
}

desenhar_figura <- function() {
  layout(matrix(c(1, 2,
                  3, 4), nrow = 2, byrow = TRUE),
         widths = c(1 - PROP_LEGENDA, PROP_LEGENDA))
  desenhar_arvore(arvore1, trait_data, cols, "A")
  desenhar_legenda(cols)
  desenhar_arvore(arvore1, trait_data1, cols1, "B")
  desenhar_legenda(cols1)
}

############################################################
# 5. Exportar
############################################################
pdf("Figura_filogenias.pdf", width = LARG_FIG, height = ALT_FIG)
desenhar_figura()
dev.off()

tiff("Figura_filogenias.tiff", width = LARG_FIG, height = ALT_FIG,
     units = "in", res = 600, compression = "lzw")
desenhar_figura()
dev.off()

png("Figura_filogenias.png", width = LARG_FIG, height = ALT_FIG,
    units = "in", res = 300)
desenhar_figura()
dev.off()
