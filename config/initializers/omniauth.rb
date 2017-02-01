Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "LKuLQ3cQomc9R2T4OzR45nCwV", "PYz9sS4rWzQJ87xPhvhJxW2iBGn2g2YtOfkQozJofRpByyNwPG"
  provider :facebook, "772269536240956", "ca269a069835ad6fcb4ed683fc10bd71"
end