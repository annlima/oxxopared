import SwiftUI

struct TermsAndConditions: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Términos y Condiciones")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                Text(termsAndConditionsText)
                    .font(.body)
                    .padding(.bottom, 20)
            }
            .padding()
        }
        .navigationBarTitle(Text("Términos y Condiciones"), displayMode: .inline)
    }
}

private let termsAndConditionsText = """
1. Aceptación de los Términos
Al acceder y utilizar nuestra aplicación, usted acepta cumplir y estar vinculado por los siguientes términos y condiciones. Si no está de acuerdo con alguno de estos términos, debe abstenerse de usar nuestros servicios.

2. Derechos Humanos y Diversidad
Nos comprometemos a respetar los derechos humanos y promover la diversidad e inclusión. Nuestros servicios están diseñados para ser accesibles y equitativos para todos, sin discriminación por raza, género, edad, discapacidad, orientación sexual, nacionalidad o cualquier otra característica personal.

3. Uso Ético de la Información
La información personal que se recolecte a través de nuestra aplicación será tratada con la máxima confidencialidad y respeto. Nos comprometemos a proteger su privacidad y a utilizar su información solo para los fines especificados y consentidos.

4. Prácticas Laborales
Aseguramos que todas nuestras operaciones respeten los principios y derechos fundamentales en el trabajo, incluyendo la prohibición de trabajo forzoso y la explotación infantil. Esperamos que nuestros proveedores y socios comerciales cumplan con estos mismos estándares.

5. Publicidad y Comunicaciones
Toda publicidad y comunicación en nuestra plataforma será honesta y transparente, evitando la publicidad engañosa y cumpliendo con los estándares éticos más altos.

6. Medio Ambiente
Nos comprometemos a operar de manera sostenible y minimizar nuestro impacto ambiental. Nuestra aplicación y servicios buscan promover prácticas que protejan y preserven el medio ambiente.

7. Cumplimiento Legal
Cumplimos con todas las leyes y regulaciones aplicables en los territorios donde operamos. Esperamos que los usuarios utilicen nuestros servicios de manera legal y responsable.

8. Modificaciones de los Términos y Condiciones
Nos reservamos el derecho de modificar estos términos y condiciones en cualquier momento. Las modificaciones entrarán en vigor inmediatamente después de su publicación en nuestra plataforma.

9. Resolución de Conflictos
Cualquier disputa relacionada con el uso de nuestros servicios será resuelta a través de mediación o arbitraje, buscando siempre una resolución justa y equitativa para todas las partes involucradas.

10. Contacto
Para cualquier pregunta o preocupación relacionada con estos términos y condiciones, por favor contacte a nuestro equipo de soporte al cliente.



"""

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditions()
    }
}
