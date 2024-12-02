
# FoxTimeEvent Mod

## Visão Geral

**FoxTimeEvent** é um mod para **Project Zomboid** desenvolvido para gerenciar eventos programados de maneira eficiente e precisa. Destinado a criadores de conteúdo e desenvolvedores de outros mods, o FoxTimeEvent oferece uma solução centralizada para verificação de tempo e acionamento de gatilhos personalizados baseados em datas específicas ou intervalos de tempo no jogo. Este mod não apenas otimiza o uso de recursos do jogo, mas também facilita a integração com múltiplos mods, promovendo uma experiência de jogo mais fluida e eficiente.

---

## Principais Utilidades

- **Gerenciamento Centralizado de Eventos Temporais:**  
  FoxTimeEvent atua como o único verificador de tempo necessário, eliminando a necessidade de múltiplos sistemas de verificação em diferentes mods.

- **Gatilhos Personalizados Baseados em Tempo:**  
  Permite a criação e gerenciamento de gatilhos de eventos personalizados que são acionados em datas específicas do jogo ou após um intervalo de tempo definido.

- **Economia de Processamento:**  
  Ao concentrar a verificação de tempo e gatilhos em um único sistema, reduz significativamente o uso de recursos, tornando o jogo mais eficiente.

- **Persistência de Dados Organizada:**  
  Armazena todas as informações de eventos de forma estruturada em arquivos de texto, garantindo a persistência dos dados entre sessões de jogo.

---

## Vantagens de Utilizar FoxTimeEvent

### 1. **Economia de Recursos**

- **Centralização de Verificações:**  
  Utilizando o FoxTimeEvent como o único verificador de tempo, evita-se a sobrecarga causada por múltiplos sistemas de verificação rodando simultaneamente.

- **Agendamento Dinâmico:**  
  O sistema ajusta a frequência das verificações (diária, horária, a cada dez minutos ou a cada minuto) com base na proximidade do próximo evento, garantindo que os recursos sejam utilizados de forma otimizada.

### 2. **Eficiência e Precisão**

- **Sistema de Comparação de Tempo Preciso:**  
  Utiliza uma comparação detalhada de unidades de tempo (ano, mês, dia, hora, minuto) para assegurar a maior precisão no acionamento de eventos.

- **Mistura de Eficiência e Precisão:**  
  Combina verificações eficientes com alta precisão, garantindo que os eventos sejam acionados no momento exato, sem desperdício de recursos.

### 3. **Facilidade de Uso e Integração**

- **API Intuitiva:**  
  Oferece funções claras e bem definidas para registrar e gerenciar eventos, facilitando a integração com outros mods.

- **Flexibilidade para Múltiplas Requisições:**  
  Capaz de processar múltiplas requisições simultaneamente através de um sistema de fila, garantindo que todos os eventos sejam gerenciados de forma ordenada e eficiente.

### 4. **Compatibilidade e Escalabilidade**

- **Adotável como Padrão:**  
  Ao ser utilizado como base para a verificação de tempo, permite que múltiplos mods se beneficiem de um sistema unificado, reduzindo a redundância e melhorando a compatibilidade entre mods.

- **Manutenção Simplificada:**  
  Com um único sistema responsável pela gestão de eventos, a manutenção e atualização tornam-se mais simples e menos propensas a conflitos.

---

## Processo de Verificação

O FoxTimeEvent utiliza um sistema de verificação dinâmico que ajusta a frequência das verificações com base na proximidade do próximo evento a ser acionado. Este processo combina eficiência e precisão, otimizando o uso de recursos do jogo.

### Frequência de Verificação

- **Mais de 26 horas restantes:** Verificação diária.
- **Entre +1 hora e -26 horas:** Verificação a cada hora.
- **Entre <=1 hora e +11 minutos:** Verificação a cada dez minutos.
- **Menos de -11 minuto:** Verificação a cada minuto.

### Benefícios

- **Eficiência:** Reduz o número de verificações necessárias quando não há eventos próximos, economizando recursos do sistema.
- **Precisão:** Aumenta a frequência das verificações à medida que o evento se aproxima, garantindo que o gatilho seja acionado no momento exato.

---

## Persistência de Dados

Todos os eventos registrados são armazenados em um arquivo de texto bem organizado, garantindo a persistência dos dados entre sessões de jogo.

### Formato do Arquivo de Eventos

Cada linha no arquivo de eventos representa um evento registrado e contém informações detalhadas sobre o evento. O formato é estruturado e fácil de entender, facilitando a integração com outros mods.

**Exemplo de Registro no Arquivo de Eventos:**

```
|id000000017_MyTestMod|2024/12/01 ((UTC)19:50:43)|NicolasLombardo|1993,6,11,9,0|1993,7,12,12,0|MyTestMod|MyTestMod_onEventTriggered|Specific date event has been triggered!|
|id000000015_MyTestMod|2024/12/01 ((UTC)19:50:43)|CharlesChild|1993,6,11,21,24|1993,7,12,12,0|MyTestMod|MyTestMod_onEventTriggered|Specific date event has been triggered!|
```

---

## Limitações da Versão Atual

- **Apenas Gatilhos Baseados em Tempo:**  
  A versão atual do FoxTimeEvent suporta apenas a criação de eventos com gatilhos baseados em datas específicas do jogo ou intervalos de tempo adicionados. Não há suporte para outros tipos de gatilhos, como mudanças climáticas, estações do ano ou eventos baseados em condições específicas do jogo.

---

## Expansões Futuras

- **Gatilhos Baseados em Eventos de Jogo:**  
  Implementar gatilhos que respondem a mudanças climáticas, estações do ano ou outros eventos dinâmicos no jogo.
  
- **Integração com Outros Sistemas de Eventos:**  
  Permitir que o FoxTimeEvent interaja com sistemas de eventos existentes em outros mods, promovendo uma maior flexibilidade e funcionalidade.
  
- **Feedback da Comunidade:**  
  Basear futuras funcionalidades e expansões nas solicitações e necessidades da comunidade de desenvolvedores de mods.

---

## Contribua com o Projeto

O FoxTimeEvent foi criado para resolver problemas enfrentados na criação de outros mods e, com isso, nasceu a intenção de ajudar a comunidade de desenvolvedores de **Project Zomboid**. O mod é de código aberto e está disponível para colaboração e aprimoramento.

### Repositório no GitHub

Você pode acessar o repositório do FoxTimeEvent, contribuir com melhorias, reportar bugs ou sugerir novas funcionalidades através do seguinte link:

🔗 **[FoxTimeEvent no GitHub](https://github.com/FoxPopBR/FoxTimeEvent)**

Created by: Foxpop