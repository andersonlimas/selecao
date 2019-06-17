require 'minitest/autorun'
require './app/use_cases/organize_conference'

describe ::UseCases::OrganizeConference, '#call' do

  describe 'when given a invalid proposals_path' do
  end

  describe 'when given a valid proposals_path' do

    it 'return an organized conference' do
      subject  = subject_instance('proposals.txt')
      conference = subject.call

      expected_track_desc = <<~DESC
#### Track A:
9:00 Diminuindo tempo de execução de testes em aplicações Rails enterprise 60min

10:00 Reinventando a roda em ASP clássico 45min

10:45 Apresentando Lua para as massas 30min

12:00 Almoço

13:00 Erros de Ruby oriundos de versões erradas de gems 45min

13:45 Erros comuns em Ruby 45min

14:30 Rails para usuários de Django lightning

14:35 Trabalho remoto: prós e cons 60min

15:35 Desenvolvimento orientado a gambiarras 45min

16:20 Aplicações isomórficas: o futuro (que talvez nunca chegaremos) 30min

16:50 Evento de Networking

#### Track B:
9:00 Codifique menos, Escreva mais! 30min

9:30 Programação em par 45min

10:15 A mágica do Rails: como ser mais produtivo 60min

12:00 Almoço

13:00 Ruby on Rails: Por que devemos deixá-lo para trás 60min

14:00 Clojure engoliu Scala: migrando minha aplicação 45min

14:45 Ensinando programação nas grotas de Maceió 30min

15:15 Ruby vs. Clojure para desenvolvimento backend 30min

15:45 Manutenção de aplicações legadas em Ruby on Rails 60min

16:45 Evento de Networking
      DESC

      _(conference.to_s).must_equal expected_track_desc
    end
  end

  def subject_instance(proposals_path)
    @subject ||= ::UseCases::OrganizeConference.new(proposals_path)
  end
end
