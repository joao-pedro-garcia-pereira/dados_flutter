//Importa a biblioteca para trabalhar com numeros aleatórios (para o dado)
import 'dart:math';
//Importa o pacote principal do flutter (widgets, design...etc)
import 'package:flutter/material.dart';

//1. ESTRUTURA BASE DO APP
//A função principal que inicia o app
void main() => runApp(
  const AplicativoJogodeDados()
);

//Raiz (base) do app. Definir o tema e o fluxo inicial 
class AplicativoJogodeDados extends StatelessWidget {
  const AplicativoJogodeDados ({super.key});


@override 
Widget build(BuildContext context){
  //Fazer um return do MaterialApp, que dá o visual ao projeto 
  return MaterialApp(
    title: 'Jogo de dados', // Titulo que aparece no gerenciador de tarefa 
    theme: ThemeData(
      primarySwatch: Colors.blue
        ),
      home: const TelaConfiguracaoJogadores(),
    );
  }
}

// 2. TELA DE CONFIGURAÇÃO DE JOGOS 
// Primeira ela do app. Coletar os nomes dos jogadores
class TelaConfiguracaoJogadores extends StatefulWidget{
  const TelaConfiguracaoJogadores({super.key});

  @override
  //cria o objeto de Estado que vai gerenciar o formulário do jogador
State<TelaConfiguracaoJogadores> createState() => _EstadoTelaConfiguracaoJogadores();
  }

  class _EstadoTelaConfiguracaoJogadores extends State<TelaConfiguracaoJogadores>{
    //Chave Global para indentificare invalidar o widget
    // Final é uma plavra chavedo do dart para criar uma váriavel que só recebe valor uma vez 
    // FormState é o estado interno desse formulário, é a parte que sabe o que esta digitado e consegue validar os campos
    final _chaveFormulario = GlobalKey<FormState>();
    //Controladores para pegar o Testo digitado nos campos 
    final TextEditingController _controladorJogador1 = TextEditingController();
    final TextEditingController _controladorJogador2 = TextEditingController();

    @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuração dos Jogadores"),
        
      ),
       body: Padding(
        padding: const EdgeInsets.all(16), //Espaçamento Interno
        child: Form(
          key: _chaveFormulario, //Associando a chave GlobalKey ao formulario
          child: Column(
            children: [
              //Campo de Texto para o Jogador numero 1
              TextFormField(
                controller: _controladorJogador1, //liga o input ao controle 
                decoration: const InputDecoration(labelText: "Nome Jogador 1"),
                validator: (valor) => valor!.isEmpty ? "Digiteum nome" : null,
                //Condição ? valor_se_verdadeiro : Valor_se_falso
                //Se o campo estiver vazio, mostre o texto Digite um nome.
              ),
              const SizedBox(height: 16),
              //Campo de Texto para o Jogador numero 2
              TextFormField(
                controller: _controladorJogador2, //liga o input ao controle 
                decoration: const InputDecoration(labelText: "Nome Jogador 2"),
                validator: (valor) => valor!.isEmpty ? "Digiteum nome" : null,
                //Condição ? valor_se_verdadeiro : Valor_se_falso
                //Se o campo estiver vazio, mostre o texto Digite um nome.
              ),
              const Spacer(), //Oculpar o espaço vertical disponivel, empurrando o botão p/ baixo
              //Fazer um botão para iniciar o jogo
              ElevatedButton(
                onPressed: (){
                  if(_chaveFormulario.currentState!.validate()){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //Criar a tela de jogo, PASSANDO os nomes digitados como Parâmetros.
                        builder: (context) => TelaJogoDeDados(
                          nomeJogador1: _controladorJogador1.text,
                          nomeJogador2: _controladorJogador2.text,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                //Botão de largura total
                child: const Text("Iniciar Jogo"),
              )
            ],
          ),
        ),
       ),
      );
    }
  }

  //3. TELA PRINCIPAL DO JOGO 

  // Aqui eu vou receber os nomes como ropriedades 
  class TelaJogoDeDados extends StatefulWidget {
    //Variáveis finais que armazenam os nomes recebidos da tela anterior
    final String nomeJogador1;
    final String nomeJogador2;

    const TelaJogoDeDados ({
      super.key,
      //O required garante que esses valores vão ser passados.
      required this.nomeJogador1,
      required this.nomeJogador2,
      });

      @override 
      //Ei tio flutter, quando essa tela for criada, use essa calsse chamada _EstadoTelaJogoDeDados para guardar e controlar o estado dela
      //ESTADOTELAJOGODEDADOS é o cérebro do Robô que guarda o que está acontecendo.
      //O createstate é o botão que coloca o cérebro dentro do robô
      State<TelaJogoDeDados> createState() => _EstadoTelaJogoDeDados();
  }

  class _EstadoTelaJogoDeDados extends State<TelaJogoDeDados>{
    final Random _aleatorio = Random(); //Gerador de números aleatórios
    //Lista dos 3 valores de cada Jogador.
    List<int> _lancamentosJogador1 = [1,1,1];
    List<int> _lancamentosJogador2 = [1,1,1];
    String _mensagemResultado = ''; //Mensagem de resultado da rodada.

    //Mapear as associções do númeroos dado referente ao link
  final Map<int, String> imagensDados = {
    1: 'https://i.imgur.com/1xqPfjc.png&#39',
    2: 'https://i.imgur.com/5ClIegB.png&#39',
    3: 'https://i.imgur.com/hjqY13x.png&#39',
    4: 'https://i.imgur.com/CfJnQt0.png&#39',
    5: 'https://i.imgur.com/6oWpSbf.png&#39', 
    6: 'https://i.imgur.com/drgfo7s.png&#39',

  };

// Lógica da pontuação: verifica combinações para aplicar os multiplicadores.
  int _calcularPontuacao(List<int> lancamentos){
      //'reduce' percorre toda a lista 
      final soma = lancamentos.reduce((a,b) => a + b);
      // [4,4,1] > 4 + 4 = 8 > 8 + 1 = 9 > soma = 9 -------- 4+4=8  8+1=9  (soma = 9)
      final valoresUnicos = lancamentos.toSet().length;
      //toSet remove repetidos
      if (valoresUnicos == 1){ //[5,5,5]. Três iguais = 3x a soma
        return soma * 3;
      }else if (valoresUnicos == 2){ //[4,4,1] Dois iguais = 2x a soma
        return soma * 2;
      }else { // EX: [1,3,6]. Todos diferentes = soma pura. 
        return soma;
      }
    }
    //Função para chama pelo botão para lançar os daods 
  void _lancarDados(){
      setState(() { //Eu uso o sublinhado _ significa que ela é privada, só pode ser usada dentro dessa classe
        //Comando crucial p/ forçar a atualização da tela 
        _lancamentosJogador1 = List.generate(3, (_) => _aleatorio.nextInt(6) + 1);
        _lancamentosJogador2 = List.generate(3, (_) => _aleatorio.nextInt(6) + 1);

        final pontuacao1 = _calcularPontuacao(_lancamentosJogador1);
        final pontuacao2 = _calcularPontuacao(_lancamentosJogador2);

        if(pontuacao1 > pontuacao2){
        _mensagemResultado = '${widget.nomeJogador1} venceu! ($pontuacao1 X $pontuacao2)';

        }else if (pontuacao2 > pontuacao1) {
        _mensagemResultado = '${widget.nomeJogador2} venceu! ($pontuacao2 X $pontuacao1)'; 
        }else {
        _mensagemResultado = 'Empate! Joguem novamente.';
        }
    });

  }
  //declara a função que devolve um widget: recebe nome jogador, lancamentos: os 3 valores do dado
  Widget _construirColunaJogador(String nome, List<int> lancamentos){
    return Expanded( //pega todo 
      child: Column(
        children: [
          Text(nome, style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, //É o justify-content:center do css
            children: lancamentos.map((valor){
              //map transforma o número do dado em um widget de imagem
              return Padding(
                padding: const EdgeInsets.all(4.0), 
                child: Image.network(
                  imagensDados[valor]!, //Pegga a url do mapa usando o 'valor do dado
                  width: 50,
                  height: 50, 
                  errorBuilder: (context, erro, StackTrace) =>
                  const Icon(Icons, size: 40),
                ),
              );
            }),
          ),
        ],
      ),
    
    );
  }

}


