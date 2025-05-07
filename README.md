# Projeto de experiência criativa relacionado ao processing.

## TO-DO Roadmap (código):

#### Inputs
- [x] Pegar input do usuário
- [x] Armazenar input em csv
- [x] Criar botão de Exibir resultados após finalizar input

#### Cálculos e resultados dos inputs
- [ ] Fazer cálculos com base no input salvo no csv
- [ ] Salvar resultado do usuário no mesmo CSV em campos adicionais
- [ ] Atualizar rank do curso em outro CSV que corresponda ao rank de cursos

#### Resultados
- [x] Retornar ao usuário de forma básica na tela os resultados (após ele clicar no botão)
- [x] No fim da tela de resultados, exibir novos botões:
        1. Dicas para deixar sua rotina mais sustentável
        2. Exibir rank dos cursos

#### Rank de cursos
- [ ] Ler CSV de rank de cursos e ordenar
- [ ] Exibir ranks em ordem na tela

#### Botões finais
- [ ] Se o usuário clicar no botão 1, chamar a API do ChatGPT ou script python que a chame para exibir um texto de dica de melhoria de rotina ao usuário com base nos cálculos e inputs
- [ ] Se o usuário clicar no botão 2, exibir rank de cursos

#### Multimídia
- [ ] Criar funcionalidade de exportação dos resultados em texto
- [ ] Exportação dos resultados em PDF
- [ ] Exportação dos resultados em planilha
- [ ] Exportação dos resultados em PDF

## TO-DO Roadmap (projeto em geral):

#### Dados
- [ ] Pensar em quais inputs deveremos usar
- [ ] Criar um documento explicando cada cálculo/ranqueamento usado referente aos inputs do usuário.
    Exemplo: Explicar como chegamos no cálculo de que se o usuário andar de carro sozinho, ele tem um gasto de 0.27 de CO2 por km. Esse dado, por exemplo, vem da EMBRAPA.
- [ ] Criar um cálculo correto para cada input do usuário com base em dados coletados na tarefa anterior
- [ ] Bases de dados para consultar e nos basear: EMBRAPA, ONU, CETESB, SEEG
    O SEEG será usado somente no final, para comparação, exemplo: “Com suas escolhas hoje, você gerou 3.2 kg de CO₂. Isso representa 0.00001% das emissões diárias médias por pessoa no Brasil segundo o SEEG.”

#### Apresentação
- [ ] Pensar em nome do projeto
- [ ] Criar apresentação do nosso projeto
