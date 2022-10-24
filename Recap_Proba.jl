### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 7741fd78-34d5-11ed-3d55-dd986e292da5
using Distributions, PlutoUI, LinearAlgebra, Markdown, InteractiveUtils, Documenter, HypertextLiteral

# ╔═╡ dea9e61d-ff0b-404a-b762-f37d4204de38
using GLMakie

# ╔═╡ e9083ca9-9542-471d-9c4d-b8382418cde8
using D3Trees, Blink, Latexify

# ╔═╡ 7f488943-6cd3-431d-8d8b-511365b4b90b
md"# WS225 TPW1: Short Recap of your course on probability

For more information, you are kindly invited to have a look at your course on Statistics and Probability. The introduction chapters of the \"Weaponeering\" (by Morris Driels) reference book also provide some additional information.
"

# ╔═╡ e9bfc4df-4b0e-4196-9acf-4e13bf44348e
TableOfContents()

# ╔═╡ e2bf1c53-7952-4ae7-8b76-f0d5e2c47e16
md"## The uniform distribution
In this notebook, each section contains an example of an application/exercise using the covered subject. Additional exercises for those not yet at ease with the distribution to do some additional exercises. The concepts inside these exercises (Probability calculations) will further be considered known and no longer elaborated on.

We will start with the uniform distribution. An easy one to start with where the probability function is \"spread\" over a certain region (a line section) The distribution outside the region (delimited with a and b) has a value of zero, within the region the value is given by: 
"

# ╔═╡ 784665d1-48b1-4ce9-8052-aa1bb72cd1a6
md"""
$$f(x) = \frac{1}{b-a}$$
"""

# ╔═╡ e87bd25a-9dec-4068-bd4f-c6885ce583dd
md" 
### Example Uniform Distribution
"

# ╔═╡ cd42407c-2405-4ea9-96f7-e1c339815757
md"""
A HE projectile is flying on an approximately horizontal trajectory. The time fuses are from an old batch, so the fuses will detonate within half a second before and after the set detonation time. It appears between these bounds all detonation times are equally probable. The projectile is flying at 230 m/s, the fuze is set to detonate on top of our target, but should detonate within 50 meters from the target. What is the probability of neutralizing the target?
"""

# ╔═╡ 745b923f-9ff8-4b57-82b4-472c9831c1ad
begin
𝒫const = round(100/230; digits=3)
md"""
##### Solution: 
The probability of neutralizing the target should be:

""" 

end

# ╔═╡ 62bc7ec9-ac3d-43cc-9706-6e63ecef8ffd
probability = 0.5

# ╔═╡ 03e2257d-4f28-42bc-af4e-fd056437a8c5
md"## The univariate normal distribution
Many physical processes exhibit the bell-shaped histogram of a normal distribution. \
❗ If you are rusty on working with normal distributions, do have a look at the process of standardization and on using a z-value table before doing additional exercises.
"

# ╔═╡ 6c1a0381-71bb-49c2-b5e4-d920b7e1029c
@bind μ PlutoUI.Slider(-3:0.5:3, default=0) 

# ╔═╡ af250525-cf88-466a-9806-0286b459203d
md"""
μ set to : $μ""" 

# ╔═╡ f4e736ec-4f66-4259-8932-ae25cbd9fc08
@bind σ PlutoUI.Slider(0.1:0.1:4, default=1)

# ╔═╡ 38aaf952-81f8-4431-addc-281486fdbca3
md""" 
σ set to : $σ""" 

# ╔═╡ 4349ac72-ce4e-4734-8f67-5d90895ed8bc
𝒩 = Normal(μ, σ)

# ╔═╡ 4daebd8b-e53b-40f8-9bd8-2ae4107d2885
begin
	x  = -10:0.1:10
	𝒩f = Figure()
	𝒩ax1 = Axis(𝒩f[1, 1], xlabel = "[]", ylabel = "𝒫",
    title = "CDF (μ = $μ and σ = $σ)")
	𝒩ax2 = Axis(𝒩f[1, 2],xlabel = "[]", title = "PDF (μ = $μ and σ = $σ)")
	𝒫ₓ_cdf = cdf.(𝒩, x)
	𝒫ₓ_pdf = pdf.(𝒩, x)
	lines!(𝒩ax1, collect(x), 𝒫ₓ_cdf)
	lines!(𝒩ax2, collect(x), 𝒫ₓ_pdf)
	xlims!(𝒩ax1, (-10, 10)); 	xlims!(𝒩ax2, -10, 10) 
	ylims!(𝒩ax1, -0.01, 1) ; 		ylims!(𝒩ax2, (-0.01, 1)) 
		
	𝒩f
 #title="CFD for the normal law with (μ = $μ and σ = $σ)")
end

# ╔═╡ 93e35a14-9729-4b1f-b2c0-af8e9c1215e3
md"
### Ballistic specific:
#### Error Probable (EP)
The error probable is used to simplify survivability calculations. Where a length of one standard deviation (σ) from the average value (μ) should contain about 68% of all data points (or in our case impact points), this value is rather impractical for fast calculations. Therefore EP is used. As for σ, one EP with respect to μ should contain half (50%) of all impact points.
"

# ╔═╡ dc1fc940-424d-4cba-94bf-7295fdbdc130
md"""
💡 the EP can be preceded by another letter giving additional information on where the EP is applicable.
- REP (Range Error Probable) (1D)
- DEP (Deflection Error Probable) (1D)
- HEP (Height Error Probable) (1D)
- CEP (Circular Error Probable) (2D)
- SEP (Spherical Error Probable) (3D)
"""

# ╔═╡ c790f444-49bb-4d21-9442-638d217908ca
@bind ep PlutoUI.Slider(0.1:0.1:3, default=0.7) 

# ╔═╡ aab16dfa-362b-4838-b014-4aba6fbe3fa6
md"""
EP set to : $ep""" 

# ╔═╡ 7e055239-97b6-48a4-a2a3-20e8ee140d45
begin
	𝒩ep = Normal(μ, ep/0.6745)
	𝒩fep = Figure()
	𝒩axep = Axis(𝒩fep[1, 1], xlabel = "[]", ylabel = "𝒫",
    title = "PDF (μ = $μ and EP = $ep)")
	𝒫ₓ_pdf_ep = pdf.(𝒩ep, x)
	lines!(𝒩axep, collect(x), 𝒫ₓ_pdf_ep, label="NL with ep")
	lines!(𝒩axep, collect(x), pdf.(Normal(μ,1),x), color="red", label="𝒩(0,1)")
	xlims!(𝒩ax1, (-10, 10))
	ylims!(𝒩ax1, -0.01, 1) 
	
	𝒩fep[1, 2] = Legend(𝒩fep, 𝒩axep, "Legend", framevisible = false)
	𝒩fep
 #title="CFD for the normal law with (μ = $μ and σ = $σ)")
end

# ╔═╡ 0b891e54-91be-475c-a48d-45c988df1795
md" 
### Example EP
A gun is aimed at a bridge 50 m long, located in the direction of fire, at a distance of 7000 m. At this distance, the LEP is 22 m. What is the probability of hitting the bridge if the aiming point is the centre of the bridge?

"

# ╔═╡ d8f28494-63a0-4c07-83c1-238d74c71925
answer = 0.9

# ╔═╡ 65ec32d2-e08f-4da7-9b8f-a0d99ab11d50
md"
#### R90
The R90 is also used to simplify survivability calculations. Where a length of one standard deviation (σ) from the average value (μ) should contain about 68% of all data points (or in our case impact points), this value is rather impractical for fast calculations. Therefore R90 can be used, mainly for artillery. R90 with respect to μ should contain 90% of all impact points.
"

# ╔═╡ 0c92ec48-8b7c-42a3-89d3-fd897d9e7115
md" 
### Example R90
An artillery piece is aimed at an advancing IFV (Infantry Fighting Vehicle) at a distance of 7000 m. At this distance, the lethal radius against an IFV is 100 m. The R90 of the weapon-ammo system at this distance is 70 m. What is the probability of neutralizing the IFV with a single round?

"

# ╔═╡ c7188e1b-9ba7-4f96-92d1-482875dc4439
probability_neutralisation = 0.7

# ╔═╡ 91f9ccfa-7e5b-46e6-a6d2-a6aaac322594
md"## The multivariate normal distribution
### Bivariate normal distribution

Let is consider axis 1 and 2 which are perpendicular.
We can define two independent normal distributions linked to one of the axis:
- 𝒩₁(μ₁, σ₁)
- 𝒩₂(μ₂, σ₂)
In the special case where σ₁ = σ₂ an easier way of calculating certain probabilities is available.
Generally in ballistics we are interested in the number of impacts or the probability of an impact within a certain area centred on the Desired Point of Impact (DPI). 
If our weapon is unbiased, the DPI should correspond to the Mean Point of Impact (MPI). \
💡 The process of removing the bias or systematic error for small arms fire is called zeroing (N/F: zerotage). \
In that case, we might want to express the desired impact zone as a circular region centred on the DPI (=MPI in the zeroed case!). \

instead of using the following equation: 
"

# ╔═╡ f179ae75-f110-4669-9a0b-5479918b1564
md"
$$\int_{}^{} \int_{}^{} \frac{1}{2\sigma^2 \pi} e^{\frac{-1}{2} {\left( \frac{x-\mu_x}{\sigma_x} \right)}^2} \! e^{\frac{-1}{2} {\left( \frac{x-\mu_y}{\sigma_y} \right)}^2}dxdy$$
"

# ╔═╡ fe9a7391-c6f5-4a42-9586-76470131fcd4
md"
If we combine x and y keeping in mind we will be considering a disk as our area of interest the integral can be replaced with the Rayleigh distribution of which the CDF is given by:
"

# ╔═╡ 4a52796b-2cef-4742-bebc-f9a6eae1f81e
md"
$$P(r \leq R) = 1-e^{\frac{-R^2}{2 \sigma^2}}$$
"

# ╔═╡ 51163392-a671-41ec-8df5-fbfce0622e7b
begin
	σᵣ = 1
	𝒩₁ = Normal(0,σᵣ)
	𝒩₂ = Normal(0,1σᵣ)
	R = 0:0.1:10
	ℛ = Rayleigh(σᵣ)

	ℛf = Figure()
	ℛax1 = Axis(ℛf[1, 1], xlabel = "[]", ylabel = "𝒫",
    title = "Rayleigh CDF (σ = $σᵣ)")
	ℛ_pdf = pdf.(ℛ, R)
	lines!(ℛax1, collect(R), ℛ_pdf)
	xlims!(ℛax1, (-0.01, 10))
	ylims!(ℛax1, -0.01, 1) 
		
	ℛf
end

# ╔═╡ 0d70fb9b-2cce-4465-9589-27978961804c
md"
### Ballistic specific:
#### Circular Error Probable (CEP)
"

# ╔═╡ a2e6a3f6-1643-4810-b30b-d760e1398922
md"
Similar to the explanation on the EP, the Circular Error Probable is often used in ballistics instead of the standard deviation. The CEP is the radius of the disc which cover 50% of all impact points
"

# ╔═╡ 537b3c21-f1bd-4ad6-ae60-5b1a35d05edd
md"""
$$CEP = 1.1774 \sigma$$
"""

# ╔═╡ 6b5afb26-8b6c-4d59-a9a5-be270854ad04
md"""
$$CEP = 1.7456 \  DEP$$
"""

# ╔═╡ 3d253278-6739-432c-9c0d-b8053ed91dd5
md" 
### Example CEP
"

# ╔═╡ 39236e74-5a9f-4002-861b-0ac5940ed5fa
md"""
The CEM (Center for Military Expertise) tested the turret and canon of a DF-90. They used 45 round and fired at a distance of 1000 meters. A 2 by 2 meter target was used to determine the impact points of the APFSDS rounds. (Armour Piercing Discarding Sabot). They determined the standard deviation of all impacts to be 50 cm in both directions, with no indication of a correlation. Each round was shot under identical conditions. The Commander Ops and Training informed you he wishes to see the following information in your report: 
- CEP at 1000 m in mils
- the probability of hitting a circle with a radius of 1 meter at 1000 meters
- the probability of hitting a 4 by 2 meter target at 2000 meters (assuming a linearly growing EP)
"""

# ╔═╡ ce68175a-f964-4111-be70-d76fa21df25f
begin

	σ_DF90 = 0.5
	CEP = 1.1774 * σ_DF90
	ℛexample = Rayleigh(σ_DF90)
	𝒫1k = cdf(ℛexample, 1) 
	# at 2000 meters the std is thus twice as big
	𝒩example = Normal(0, 1)
	𝒫2kx = 1 - cdf(𝒩example, -2) *2 
	𝒫2ky = 1 - cdf(𝒩example, -1) *2
	𝒫2ktotal =  𝒫2kx * 𝒫2ky
	md""
end

# ╔═╡ 083b70d2-74a4-44d8-904f-d491993a0ee2
CEP_1000m = 0.59

# ╔═╡ 31eb54e6-8ceb-4863-8760-9897457049ba
probability_1m_circle = 0.9

# ╔═╡ 41c8f345-258d-45ee-96b0-0c77c2618879
probability_2km_tgt = 0.65

# ╔═╡ 84ed4a72-5902-446c-9533-e3b97fa52002
md"
#### Equivalent Circular Error Probable (ECEP)
"

# ╔═╡ 84169a90-51d3-49e4-a2e6-c3553a6cb1ce
md"
For Direct Fire (DF) the hypothesis of having equal standard deviations might hold true, but for Indirect Fire (IDF) or projectiles with a greater time of flight (tof) the projectiles might be influenced more in one axis. In general, artillery shells will have a larger dispersion in range (compared to deflection). Which will cause the equi-probability-curves to become elliptical instead of circular.
"

# ╔═╡ 6048aad3-c71e-4aac-83fe-2e03ae1ed87b
@bind e PlutoUI.Slider(0.1:0.1:1, default=0.8) 


# ╔═╡ 34841284-a04b-49bd-9f48-901ca36b5a0b
begin
		σᵢ = 1.0
		ratio = e
		ex𝒩ᵢ = Normal(0,σᵢ)
		ex𝒩ⱼ = Normal(0,σᵢ*ratio)
		xs = LinRange(-3, 3, 100)
		ys = LinRange(-3, 3, 100)
		zs = [pdf(ex𝒩ᵢ,x)*pdf(ex𝒩ⱼ,y) for x in xs, y in ys]
		ex𝒩 = Figure()
		exℛax1 = Axis(ex𝒩[1, 1], xlabel = "[]", ylabel = "[]",
    	title = "contourmap (σᵢ = $σᵢ, ratio = $ratio)")
		contour!(exℛax1,xs, ys, zs)
		exℛax1.aspect = AxisAspect(1)
	

	xcep = LinRange(-1.1774,1.1774,1000)
	
	drawellips = sqrt.(1.1774^2 .- xcep.^2) .* e
	if e ≥ 0.5
		eqCEP = 1.1774*(σᵢ+σᵢ*e)/2
	else
		eqCEP = 0.562*σᵢ + 0.617*σᵢ*e
	end
	xecep = LinRange(-eqCEP, eqCEP, 1000)
	drawecep = sqrt.(eqCEP^2 .- xecep.^2)
		comp_ax = Axis(ex𝒩[1, 2], xlabel = "[]", ylabel = "[]",
    	title = "comparison CEP - ECEP (σᵢ = $σᵢ, ratio = $ratio)")
		lines!(comp_ax, xecep, drawecep, color = "blue", label = "ECEP")
		lines!(comp_ax, xecep, -drawecep, color = "blue")
		lines!(comp_ax, xcep, drawellips, color = "red", label = "ellips")
		lines!(comp_ax, xcep, -drawellips, color = "red")
		comp_ax.aspect = AxisAspect(1)
		ex𝒩[1, 3] = Legend(ex𝒩, comp_ax, "Legend", framevisible = false)
		ex𝒩

end

# ╔═╡ 4c26a695-752f-4519-8941-8be66c424510
md"""
We define $$\sigma_s = min(\sigma_x, \sigma_y)$$ and $$\sigma_l = max(\sigma_x, \sigma_y)$$
"""

# ╔═╡ 4524a8d6-ab46-40aa-b556-e83fe7b734c9
md"""
💡 ECEP Rule:
- ratio standard deviations is no smaller than 0.5
use: $$CEP = 1.1774 \ \frac{\sigma_x+\sigma_y}{2}$$ or $$\ CEP = 1.1774 \ \sqrt{\frac{{\sigma_x}^2+{\sigma_y}^2}{2}}$$ or $$\ CEP = 1.1774 \ \sqrt{\sigma_x\sigma_y}$$
- ratio smaller than 0.5
use: $$CEP = 0.562 \ \sigma_l + 0.617 \ \sigma_s$$
   (Pittsman's equation) 
"""

# ╔═╡ 05f1a282-37f2-459d-aa4a-c4e394b6b191
md" 
### Example ECEP
"

# ╔═╡ 515cabfa-42c9-443a-841a-3027294e71e3
md"""
A 80 mm mortar is tested at the shooting range in Elsenborn at a range of 3 km. During the analysis of impact points, the shooting officer observed a different standard deviation in range and deflection. He/She noted $$\sigma_{range} = 10 \ m$$ and $$\sigma_{defl} = 6 \ m$$ \

Our munition is lethal against a vehicle up to 8 m  from the detonation point.\

If we aim at the vehicle (unbiased weapon), what is the probability of neutralizing the vehicle?
"""

# ╔═╡ 29438117-b3b0-4b7f-976d-772d1aef906c
begin
	# The ratio is larger than 0.5 so we should use one of the proposed mean values instead of the Pittsman's equation.
	
	exECEP = 1.1774 * (10+6)/2
	exEσ = (10+6)/2
	𝒫ℋ = cdf(Rayleigh(exEσ), 8)
	𝒫𝒦ex = round(𝒫ℋ * 1; digits =3) # no additional info is given, so within the 8 m radius every hit is a kill, outside the circle no hit results in a kill. (cookie cutter principle)
md"#### Solution:"
end

# ╔═╡ dac5e3ec-d340-46cb-a588-b982dd21c8ed
	md"
	exECEP = 1.1774 * (10+6)/2
	exEσ = (10+6)/2
	𝒫ℋ = cdf(Rayleigh(exEσ), 8)
	𝒫𝒦ex = 𝒫ℋ * 1
	"

# ╔═╡ e3cebd0a-7d16-4e3d-bc3f-9bb351b53bc8
md"The probability of neutralizing the vehicle is: $𝒫𝒦ex"


# ╔═╡ 5f9012d2-8b13-4637-8451-d09339013211
md"## The binomial distribution
"

# ╔═╡ 8ab3b51e-b527-4731-905b-16d21a4f804b
md"""
In a Binomial \"game\" there are two outcomes of an action (hence \"bi\"nomial). The probability of both outcomes does not have to be equal. There can be one event rarer than the other. 

💡 If the one event becomes truly rare → see 𝒫oisson distribution

Often, bifurcating trees are used to visually represent the system. Be careful, as more events take place, these event or probability trees grow exponentially.

As these trees grow exponentially, the number of outcomes grows exponentially
"""

# ╔═╡ bd180b4b-58b2-4921-8ea7-736997956e63
begin
	children1 = [[2, 3], [4,5], [6,7], [8,9], [10,11], [12,13], [14,15]]
	text1 = ["coin toss", "heads", "tails", "heads", "tails","heads", "tails","heads", "tails","heads", "tails","heads", "tails","heads", "tails",]
	link_style1 = ["", "", "", ""]
	tooltip1 = ["pops", "up", "on", "hover"]
	t1 = D3Tree(children1,
	    text=text1,
	    tooltip=tooltip1,
	    link_style=link_style1,
	    title="Binomial distribution",
	    init_expand=0)
end

# ╔═╡ b7480d83-b166-4fed-8afc-685f15d2213d
md"""
When we are looking for n occurrences of one outcome out of N samples, the probability of this outcome can be calculated using:
$$P(n \ out \ of \ N) = C^n_N p^n q^{N-n}$$
"""

# ╔═╡ 345ddf60-b261-4be4-93ff-bd9a15ac9cdd
md"""
Do keep in mind, this equation only counts if the order of events is of no significance! \
Recall above going down the decision tree we are multiplying probabilities. Once at the leaves (when we start considering multiple outcomes) we add probabilities of outcome!
"""

# ╔═╡ b7df18e3-25ed-4693-b546-88e9ea7731d2
md" 
### Example Binomial distribution
"

# ╔═╡ f0b1133f-8607-4882-a85f-49603f09247a
md"""
We consider an AA unit confronted with an inbound bomber. The RADAR system is generally out for half an hour every 50 hours. \
Due to the detection threshold, one out of ten bombers will not be detected (False negative). \
If a detection occurs, a firing solution will be available 95 percent of the time. \
In 90 percent of cases, a successful launch will result in a succesful Intercept trajectory for the projectile.\
95 percent of projectiles on the correct trajectory will cause a hit of the target.\
Hitting the target will result in a successful neutralization of the aircraft 4 out of 5 times.
"""

# ╔═╡ 7eb8c42e-4234-4613-ae18-f5267719756c
begin
	children = [[2, 3], [], [4, 5], [], [6,7], [], [8, 9],[], [10,11], [], [12,13], [], []]
	text = ["Kill chain", "survive", "𝒫A (0.99)", "survive", "𝒫D/A (0.8)", "survive", "𝒫L/D (0.95)", "survive", "𝒫I/L (0.9)", "survive", "𝒫H/I (0.95)", "survive", "𝒫K/H (0.8)"]
	link_style = ["", "",  "stroke:blue", "", "stroke:blue","",  "stroke:blue","",  "stroke:blue","",  "stroke:blue","",  "stroke:blue",]
	tooltip = ["pops", "up", "on", "hover"]
	t = D3Tree(children,
	    text=text,
	    tooltip=tooltip,
	    link_style=link_style,
	    init_expand=1)
end

# ╔═╡ dfb39376-a2c1-4ca3-bffc-2bde7f8a3017
begin
	𝒫A = 0.99
	𝒫DA = 0.8
	𝒫LD = 0.95
	𝒫IL = 0.9
	𝒫HI = 0.95
	𝒫KH = 0.8
	
	𝒫K = 𝒫A * 𝒫DA * 𝒫LD * 𝒫IL * 𝒫HI * 𝒫KH
	md" "
end

# ╔═╡ 94031694-2453-4a41-a63e-4d02bfe1c46d
	md" the probability the bomber is killed is : "

# ╔═╡ 5c38fd4c-5821-4b87-b320-844599cf13b9
𝒫𝒦 = 0.5

# ╔═╡ 0910630c-1faf-4288-b165-fc9827965b55
md"""
The probability can also be calculated differently by using the kill tree:\
$$P_K = 1 - \overline{P_A} + \overline{P_{D/A}}+ \overline{P_{L/D}}+ \overline{P_{I/L}}+ \overline{P_{H/I}}+ \overline{P_{K/H}}$$

🐒 this equation is not right! Can you find the right one?

"""

# ╔═╡ a7cb3cfa-324e-43af-98dc-03d4288cb646
md"""
⚠ We use addition instead of multiplication because actually each branch on the left side can be lengthened to the "leaf"-level without additional multiplications. So even though they are higher up in the kill chain or event tree, they are terminal states or outcomes.
"""

# ╔═╡ a95cd278-e143-44bb-b80c-b815def5f1ee
md"
### Ballistic specific:
#### Survival Rate (SR), Loss Rate (LR)
"

# ╔═╡ 8951efe4-5c51-4b0e-8690-efc2e506ba87
md"""
Generally, the loss or survival rate is used to describe the percentage of elements remaining after a certain mission. For example, the number of successful sorties over the total number of sorties.
"""

# ╔═╡ c4016786-2d5e-4502-9e76-908070ca1a56
md"## The Poisson distribution
"

# ╔═╡ b01ff607-18f0-48c6-b48e-af3d0b8f5022
md"""
When an event or occurrence is rare, the Poisson distribution can be used to predict occurrences of this rare event.
For Poisson distributions, we do not use σ  rather we use α. \
We define α as n.p with n the number of samples and p the probability of the rare occurrence.\
The probability distribution function is than given by:
"""

# ╔═╡ a986b090-ab7d-48b3-8af5-af3291220fa6
md"""
$$f(x) = \frac{\alpha^x e^{-\alpha}}{x!}$$
"""

# ╔═╡ cc21a707-65e3-4c20-a700-83831994e81e
md"""
The probability of one or a few events occur α = μt 
"""

# ╔═╡ cb8e4b16-0186-4be4-b34f-1395849d369a
md"""
$$P(x \ event \ within \ time \ t) = e^{=\mu t} \frac{(\mu t)^x}{x!}$$
"""

# ╔═╡ 28ec5119-e0ae-4faf-9a54-97ca3c651dbf
md" 
### Example Poisson
"

# ╔═╡ fa299038-6b25-400b-9cb2-bcbedd737570
md"""
A team of deminers defused 12,000 unexploded ordnances (UXO's) in 4 months. One deminer handles one UXO at a time and does this on his own. During the 4 months, 3 deminers were seriously injured, causing them not to continue the mission. 
- Suppose the acceptable probability of injury during those 4 months is 5%, how many mines is a deminer allowed to defuze? 
- Suppose the deminers have to stay one month longer, and during that period they have to defuse 3000 more mines. Calculate the probability of 2 deminers being injured during that period. 
"""

# ╔═╡ 60e4f15e-acf1-48bb-84cc-c8486f4397bb
begin

md"""
##### Answer:
"""
end

# ╔═╡ 9bfb0109-4ff3-44b4-aa94-907f4b8c8cb6
begin
	α = 3
	ntot = 12000
	μP = 3/4
	tP = 4
	#SR = exp(- μP*tP)*(μP*tP)^0/factorial(0)
	#LR = 1-SR
	α_new =  -log(0.95)
	n = 120000*α_new
	𝒫₂ = exp(-α)*(α)^2/factorial(2)
	md" "
end

# ╔═╡ 9064f74b-1a2e-491c-95c3-7d55f62034d8
number_of_mines = 6155

# ╔═╡ 7138ccac-f653-4659-b192-c3712843ee6c
𝒫2deminers = 0.13

# ╔═╡ 2949fc37-7f65-45ca-ab0b-0332291cbcc4
md"## Combining distributions
"

# ╔═╡ 24531084-7277-4e8a-b367-c91bf7ba150d
md"""
❓ When multiple normal distributions are involved, the standard deviations ... ❓ \
I would perhaps add the part on: x = y + z ⇒ $$\sigma_x = \sqrt{{\sigma_y}^2+{\sigma_z}^2}$$
"""

# ╔═╡ e2a45a98-51cb-4801-850e-a286d950d270
md"## χ²-test
"

# ╔═╡ 6e5255c6-525e-49fc-9acb-641c597b26dd
md"
❓ do we add this one? ❓
"

# ╔═╡ e74f2c3d-561e-4776-9d37-d0032343a806
#-------------------------------------------------------------------------
# This notebook written to support the practical sessions for the 
# survivability course at the RMA/DEAO/Dept ABAL.#
#
# Property of the Belgian Royal Military Department, Ballistics Department
#                                          author/editor: Vancaeyzeele T.
#-------------------------------------------------------------------------

md"*[Contact us](mailto:tom.vancaeyzeele@dymasec.be)*.
"

# ╔═╡ 46359fb5-c34d-4c42-9032-13291caf5e0b
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]));

# ╔═╡ e87272f9-cfce-4835-bd04-a0b81761cda2
	hint(md"the sum of all these probabilities can be greater than one which shouldn't be, don't you think?")

# ╔═╡ d79ba202-9de5-4388-b489-315505167b70
solution(text) = Markdown.MD(Markdown.Admonition("solution", "Solution", [text]));

# ╔═╡ 96a47987-686a-4b74-8185-39c9f09e09f1
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]));

# ╔═╡ ef9ba72b-503d-4704-8544-642d279640a4
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]));

# ╔═╡ 34407cae-7ca2-4dae-a836-11633ecda551
correct(text=md"Great! You got the right answer! Let's move on to the next section.") = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]));

# ╔═╡ 8a8c0d29-79de-4463-a1c2-63cbbfbc019e
if !isapprox(probability, 𝒫const)
	hint(md"The HE can basically explode over the distance travelled in 1 second and is effective during 100 meters of this distance")
else
	correct()
end

# ╔═╡ d210926a-f42f-4bb5-9ed3-67896931d8d2
begin
LEP = 22
σₑₚ = 22/0.6745
Dist = Normal(7000,σₑₚ)
P = -cdf(Dist , 6975) + cdf(Dist , 7025) 


if isapprox(answer, P)
	correct()
else
	keep_working()
end
end

# ╔═╡ 964aaeef-9559-4f77-aa3c-a8cc5a2b2228
begin
	R90 = 120
	σR90 = R90/2.146
	DistR90 = Normal(0, σR90)
	𝒫R90 = (1-cdf(DistR90, 50))*2

	
if isapprox(probability_neutralisation, 𝒫R90)
	correct()
else
	keep_working()
end
end

# ╔═╡ 3479272e-06b1-4ec1-9d3d-f6259799a480
if floor(CEP; digits = 3) ≤ CEP_1000m ≤ ceil(CEP; digits = 3)
	correct()
else
	keep_working()
end

# ╔═╡ 88aa53f3-be74-4af3-b0f0-fb3db32482f9
if floor(𝒫1k; digits = 3) ≤ probability_1m_circle ≤ ceil(𝒫1k; digits = 3)
	correct()
else
	keep_working()
end

# ╔═╡ bdc70a8c-b260-4764-b07c-2177277ddd89
if floor(𝒫2ktotal; digits = 3) ≤ probability_2km_tgt ≤ ceil(𝒫2ktotal; digits = 3)
	correct()
else
	keep_working()
end

# ╔═╡ 287fd3e8-ed6e-45a9-b806-da3e566993a6
if floor(𝒫K; digits = 3) ≤ 𝒫𝒦 ≤ ceil(𝒫K; digits = 3)
	correct()
else
	hint(md"𝒫K = 𝒫A.𝒫D/A.𝒫L/D.𝒫I/L.𝒫H/I. 𝒫K/H")
end

# ╔═╡ d7a5d690-5fc1-457f-bea2-4cd68c84d591
if isapprox(number_of_mines, n; atol=5)
	correct()
else
	keep_working()
end

# ╔═╡ b0eafcbf-f70d-4416-ab24-192c937c7bee
if isapprox(𝒫2deminers, 𝒫₂; atol=0.002)
	correct()
else
	keep_working()
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Blink = "ad839575-38b3-5650-b840-f874b8c74a25"
D3Trees = "e3df1716-f71e-5df9-9e2d-98e193103c45"
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
Documenter = "e30172f5-a6a5-5a46-863b-614d45cd2de4"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
Latexify = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Blink = "~0.12.5"
D3Trees = "~0.3.2"
Distributions = "~0.25.71"
Documenter = "~0.27.23"
HypertextLiteral = "~0.9.4"
Latexify = "~0.15.17"
PlutoUI = "~0.7.40"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.0"
manifest_format = "2.0"
project_hash = "9e7d8c4d3525f4cc83a3ee64445208ea248d8b22"

[[deps.ANSIColoredPrinters]]
git-tree-sha1 = "574baf8110975760d391c710b6341da1afa48d8c"
uuid = "a4c015fc-c6ff-483c-b24f-f7ea428134e9"
version = "0.0.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AssetRegistry]]
deps = ["Distributed", "JSON", "Pidfile", "SHA", "Test"]
git-tree-sha1 = "b25e88db7944f98789130d7b503276bc34bc098e"
uuid = "bf4720bc-e11a-5d0c-854e-bdca1663c893"
version = "0.1.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BinDeps]]
deps = ["Libdl", "Pkg", "SHA", "URIParser", "Unicode"]
git-tree-sha1 = "1289b57e8cf019aede076edab0587eb9644175bd"
uuid = "9e28174c-4ba2-5203-b857-d8d62c4213ee"
version = "1.0.2"

[[deps.Blink]]
deps = ["Base64", "BinDeps", "Distributed", "JSExpr", "JSON", "Lazy", "Logging", "MacroTools", "Mustache", "Mux", "Reexport", "Sockets", "WebIO", "WebSockets"]
git-tree-sha1 = "08d0b679fd7caa49e2bca9214b131289e19808c0"
uuid = "ad839575-38b3-5650-b840-f874b8c74a25"
version = "0.12.5"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "dc4405cee4b2fe9e1108caec2d760b7ea758eca2"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.5"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "5856d3031cdb1f3b2b6340dfdc66b6d9a149a374"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.2.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.D3Trees]]
deps = ["AbstractTrees", "JSON", "Random"]
git-tree-sha1 = "666c295cb25d7f888bef137ce5cb1ba254cd5c4b"
uuid = "e3df1716-f71e-5df9-9e2d-98e193103c45"
version = "0.3.2"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "ee407ce31ab2f1bacadc3bd987e96de17e00aed3"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.71"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "5158c2b41018c5f7eb1470d558127ac274eca0c9"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.1"

[[deps.Documenter]]
deps = ["ANSIColoredPrinters", "Base64", "Dates", "DocStringExtensions", "IOCapture", "InteractiveUtils", "JSON", "LibGit2", "Logging", "Markdown", "REPL", "Test", "Unicode"]
git-tree-sha1 = "6030186b00a38e9d0434518627426570aac2ef95"
uuid = "e30172f5-a6a5-5a46-863b-614d45cd2de4"
version = "0.27.23"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "87519eb762f85534445f5cda35be12e32759ee14"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.4"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FunctionalCollections]]
deps = ["Test"]
git-tree-sha1 = "04cb9cfaa6ba5311973994fe3496ddec19b6292a"
uuid = "de31a74c-ac4f-5751-b3fd-e18cd04993ca"
version = "0.5.0"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.Hiccup]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "6187bb2d5fcbb2007c39e7ac53308b0d371124bd"
uuid = "9fb69e20-1954-56bb-a84f-559cc56a8ff7"
version = "0.2.2"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions", "Test"]
git-tree-sha1 = "709d864e3ed6e3545230601f94e11ebc65994641"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.11"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSExpr]]
deps = ["JSON", "MacroTools", "Observables", "WebIO"]
git-tree-sha1 = "b413a73785b98474d8af24fd4c8a975e31df3658"
uuid = "97c1335a-c9c5-57fe-bc5d-ec35cebe8660"
version = "0.5.4"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[deps.Lazy]]
deps = ["MacroTools"]
git-tree-sha1 = "1370f8202dac30758f3c345f9909b97f53d87d3f"
uuid = "50d2b5c4-7a5e-59d5-8109-a42b560f39c0"
version = "0.15.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "ae6676d5f576ccd21b6789c2cbe2ba24fcc8075d"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.5"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.Mustache]]
deps = ["Printf", "Tables"]
git-tree-sha1 = "1e566ae913a57d0062ff1af54d2697b9344b99cd"
uuid = "ffc61752-8dc7-55ee-8c37-f3e9cdd09e70"
version = "1.0.14"

[[deps.Mux]]
deps = ["AssetRegistry", "Base64", "HTTP", "Hiccup", "Pkg", "Sockets", "WebSockets"]
git-tree-sha1 = "82dfb2cead9895e10ee1b0ca37a01088456c4364"
uuid = "a975b10e-0019-58db-a62f-e48ff68538c9"
version = "0.7.6"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "dfd8d34871bc3ad08cd16026c1828e271d554db9"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "cf494dca75a69712a72b80bc48f59dcf3dea63ec"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.16"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "3d5bf43e3e8b412656404ed9466f1dcbf7c50269"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.0"

[[deps.Pidfile]]
deps = ["FileWatching", "Test"]
git-tree-sha1 = "2d8aaf8ee10df53d0dfb9b8ee44ae7c04ced2b03"
uuid = "fa939f87-e72e-5be4-a000-7fc836dbe307"
version = "1.3.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "a602d7b0babfca89005da04d89223b867b55319f"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.40"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "3c009334f45dfd546a16a57960a821a1a023d241"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.5.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "5783b877201a82fc0014cbf381e7e6eb130473a4"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.0.1"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIParser]]
deps = ["Unicode"]
git-tree-sha1 = "53a9f49546b8d2dd2e688d216421d050c9a31d0d"
uuid = "30578b45-9adc-5946-b283-645ec420af67"
version = "0.4.1"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.WebIO]]
deps = ["AssetRegistry", "Base64", "Distributed", "FunctionalCollections", "JSON", "Logging", "Observables", "Pkg", "Random", "Requires", "Sockets", "UUIDs", "WebSockets", "Widgets"]
git-tree-sha1 = "a8bbcd0b08061bba794c56fb78426e96e114ae7f"
uuid = "0f1e0344-ec1d-5b48-a673-e5cf874b6c29"
version = "0.8.18"

[[deps.WebSockets]]
deps = ["Base64", "Dates", "HTTP", "Logging", "Sockets"]
git-tree-sha1 = "f91a602e25fe6b89afc93cf02a4ae18ee9384ce3"
uuid = "104b5d7c-a370-577a-8038-80a2059c5097"
version = "1.5.9"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "fcdae142c1cfc7d89de2d11e08721d0f2f86c98a"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.6"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─7f488943-6cd3-431d-8d8b-511365b4b90b
# ╟─e9bfc4df-4b0e-4196-9acf-4e13bf44348e
# ╠═7741fd78-34d5-11ed-3d55-dd986e292da5
# ╠═dea9e61d-ff0b-404a-b762-f37d4204de38
# ╟─e2bf1c53-7952-4ae7-8b76-f0d5e2c47e16
# ╟─784665d1-48b1-4ce9-8052-aa1bb72cd1a6
# ╟─e87bd25a-9dec-4068-bd4f-c6885ce583dd
# ╟─cd42407c-2405-4ea9-96f7-e1c339815757
# ╟─745b923f-9ff8-4b57-82b4-472c9831c1ad
# ╠═62bc7ec9-ac3d-43cc-9706-6e63ecef8ffd
# ╟─8a8c0d29-79de-4463-a1c2-63cbbfbc019e
# ╟─03e2257d-4f28-42bc-af4e-fd056437a8c5
# ╟─af250525-cf88-466a-9806-0286b459203d
# ╟─6c1a0381-71bb-49c2-b5e4-d920b7e1029c
# ╟─38aaf952-81f8-4431-addc-281486fdbca3
# ╟─f4e736ec-4f66-4259-8932-ae25cbd9fc08
# ╟─4349ac72-ce4e-4734-8f67-5d90895ed8bc
# ╟─4daebd8b-e53b-40f8-9bd8-2ae4107d2885
# ╟─93e35a14-9729-4b1f-b2c0-af8e9c1215e3
# ╟─dc1fc940-424d-4cba-94bf-7295fdbdc130
# ╟─aab16dfa-362b-4838-b014-4aba6fbe3fa6
# ╟─c790f444-49bb-4d21-9442-638d217908ca
# ╟─7e055239-97b6-48a4-a2a3-20e8ee140d45
# ╟─0b891e54-91be-475c-a48d-45c988df1795
# ╠═d8f28494-63a0-4c07-83c1-238d74c71925
# ╟─d210926a-f42f-4bb5-9ed3-67896931d8d2
# ╟─65ec32d2-e08f-4da7-9b8f-a0d99ab11d50
# ╟─0c92ec48-8b7c-42a3-89d3-fd897d9e7115
# ╠═c7188e1b-9ba7-4f96-92d1-482875dc4439
# ╟─964aaeef-9559-4f77-aa3c-a8cc5a2b2228
# ╟─91f9ccfa-7e5b-46e6-a6d2-a6aaac322594
# ╟─f179ae75-f110-4669-9a0b-5479918b1564
# ╟─fe9a7391-c6f5-4a42-9586-76470131fcd4
# ╟─4a52796b-2cef-4742-bebc-f9a6eae1f81e
# ╟─51163392-a671-41ec-8df5-fbfce0622e7b
# ╟─0d70fb9b-2cce-4465-9589-27978961804c
# ╟─a2e6a3f6-1643-4810-b30b-d760e1398922
# ╟─537b3c21-f1bd-4ad6-ae60-5b1a35d05edd
# ╟─6b5afb26-8b6c-4d59-a9a5-be270854ad04
# ╟─3d253278-6739-432c-9c0d-b8053ed91dd5
# ╟─39236e74-5a9f-4002-861b-0ac5940ed5fa
# ╟─ce68175a-f964-4111-be70-d76fa21df25f
# ╠═083b70d2-74a4-44d8-904f-d491993a0ee2
# ╟─3479272e-06b1-4ec1-9d3d-f6259799a480
# ╠═31eb54e6-8ceb-4863-8760-9897457049ba
# ╟─88aa53f3-be74-4af3-b0f0-fb3db32482f9
# ╠═41c8f345-258d-45ee-96b0-0c77c2618879
# ╟─bdc70a8c-b260-4764-b07c-2177277ddd89
# ╟─84ed4a72-5902-446c-9533-e3b97fa52002
# ╟─84169a90-51d3-49e4-a2e6-c3553a6cb1ce
# ╟─6048aad3-c71e-4aac-83fe-2e03ae1ed87b
# ╟─34841284-a04b-49bd-9f48-901ca36b5a0b
# ╟─4c26a695-752f-4519-8941-8be66c424510
# ╟─4524a8d6-ab46-40aa-b556-e83fe7b734c9
# ╟─05f1a282-37f2-459d-aa4a-c4e394b6b191
# ╟─515cabfa-42c9-443a-841a-3027294e71e3
# ╟─29438117-b3b0-4b7f-976d-772d1aef906c
# ╟─dac5e3ec-d340-46cb-a588-b982dd21c8ed
# ╟─e3cebd0a-7d16-4e3d-bc3f-9bb351b53bc8
# ╟─5f9012d2-8b13-4637-8451-d09339013211
# ╟─8ab3b51e-b527-4731-905b-16d21a4f804b
# ╟─bd180b4b-58b2-4921-8ea7-736997956e63
# ╟─b7480d83-b166-4fed-8afc-685f15d2213d
# ╟─345ddf60-b261-4be4-93ff-bd9a15ac9cdd
# ╟─e9083ca9-9542-471d-9c4d-b8382418cde8
# ╟─b7df18e3-25ed-4693-b546-88e9ea7731d2
# ╟─f0b1133f-8607-4882-a85f-49603f09247a
# ╟─7eb8c42e-4234-4613-ae18-f5267719756c
# ╟─dfb39376-a2c1-4ca3-bffc-2bde7f8a3017
# ╟─94031694-2453-4a41-a63e-4d02bfe1c46d
# ╠═5c38fd4c-5821-4b87-b320-844599cf13b9
# ╠═287fd3e8-ed6e-45a9-b806-da3e566993a6
# ╟─0910630c-1faf-4288-b165-fc9827965b55
# ╟─e87272f9-cfce-4835-bd04-a0b81761cda2
# ╟─a7cb3cfa-324e-43af-98dc-03d4288cb646
# ╟─a95cd278-e143-44bb-b80c-b815def5f1ee
# ╟─8951efe4-5c51-4b0e-8690-efc2e506ba87
# ╟─c4016786-2d5e-4502-9e76-908070ca1a56
# ╟─b01ff607-18f0-48c6-b48e-af3d0b8f5022
# ╟─a986b090-ab7d-48b3-8af5-af3291220fa6
# ╟─cc21a707-65e3-4c20-a700-83831994e81e
# ╟─cb8e4b16-0186-4be4-b34f-1395849d369a
# ╟─28ec5119-e0ae-4faf-9a54-97ca3c651dbf
# ╟─fa299038-6b25-400b-9cb2-bcbedd737570
# ╟─60e4f15e-acf1-48bb-84cc-c8486f4397bb
# ╟─9bfb0109-4ff3-44b4-aa94-907f4b8c8cb6
# ╟─9064f74b-1a2e-491c-95c3-7d55f62034d8
# ╟─d7a5d690-5fc1-457f-bea2-4cd68c84d591
# ╠═7138ccac-f653-4659-b192-c3712843ee6c
# ╟─b0eafcbf-f70d-4416-ab24-192c937c7bee
# ╟─2949fc37-7f65-45ca-ab0b-0332291cbcc4
# ╟─24531084-7277-4e8a-b367-c91bf7ba150d
# ╟─e2a45a98-51cb-4801-850e-a286d950d270
# ╟─6e5255c6-525e-49fc-9acb-641c597b26dd
# ╟─e74f2c3d-561e-4776-9d37-d0032343a806
# ╟─46359fb5-c34d-4c42-9032-13291caf5e0b
# ╟─d79ba202-9de5-4388-b489-315505167b70
# ╟─96a47987-686a-4b74-8185-39c9f09e09f1
# ╟─ef9ba72b-503d-4704-8544-642d279640a4
# ╟─34407cae-7ca2-4dae-a836-11633ecda551
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
