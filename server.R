
library(shiny)
library(RMeCab)
library(tidyverse)
library(dplyr)
library(igraph)

shinyServer(function(input, output) {
  
  observeEvent(input$file,{        #ファイルの読込み
    DF <- reactive(read.csv(input$file$datapath,header=T, fileEncoding="SJIS"))
    
    temp <- tempfile()　　　　　
    DF() %>% 
      pull("txt") %>%
      write(file=temp)   
    
    DFaa <- RMeCabFreq(temp)
    DFaa <- DFaa[!(DFaa$Info1=="記号"
                             | DFaa$Info1=="助詞"
                             | DFaa$Info1=="接頭語"
                             | DFaa$Info1=="連体詞"
                             | DFaa$Info1=="接頭詞"
                             | DFaa$Info2=="数"
                             | DFaa$Info2=="接尾"
                             | DFaa$Info2=="*"
                             | DFaa$Info2=="非自立"
                             | DFaa$Term==":"
                             | DFaa$Term=="("
                             | DFaa$Term=="/"
                             | DFaa$Term==")"
                             | DFaa$Term=="-"
                             | DFaa$Term==","
                             | DFaa$Term=="~"
                             | DFaa$Term=="?"
                             | DFaa$Term=="."
                             | DFaa$Term=="～"
                             | DFaa$Term==","
                             | DFaa$Term=="<"
                             | DFaa$Term==">"
                             | DFaa$Term=="+"
                             | DFaa$Term=="!"
    ),]
    
    DFaa <- arrange(DFaa,-DFaa$Freq)
    
    
    
    ngram <- NgramDF(temp,
                     type = 1,#単語の共起語
                     N=2,#2単語を繋げる
                     pos=c("名詞","動詞","形容詞","形容動詞","副詞"))
    
    
    
    
    Nmin_size <-(input$Nmin)
    
    output$table <- renderTable({
      DFaa
    })
    
    output$Coocnet <- renderPlot({
      
      plot(graph.data.frame(filter(ngram,Freq>=Nmin_size),directed = F),
           vertex.size=10,
           vertex.label.font=1, 　　　　 #ラベルのフォントの調整
           vertex.label.color="black",　 #ラベルの色の調整
           vertex.label.cex=1,　　　　　 #ラベルの大きさの調整
           vertex.frame.color="#00FFFF", #ノードの枠の色
           vertex.color="#0FFFFF",　　　 #ノードの色
           family="HiraKakuPro-W3",      #日本語を表示させる
           vertex.label.dist=0
      )
    })
  })
})
