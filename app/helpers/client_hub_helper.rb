module ClientHubHelper
  # Podtitulek client hubu — zákazník má hned vědět, jestli se po něm něco chce.
  def client_hub_subtitle(job, quote)
    return "Máte připravenou nabídku ke schválení" if quote&.waiting_for_customer?
    return "Termín máme domluvený, ozveme se před příjezdem" if job.status == "scheduled"
    return "Pracujeme na tom" if job.status == "in_progress"
    return "Zakázka je hotová" if job.status == "completed"

    "Přehled vaší zakázky"
  end
end
