### A Pluto.jl notebook ###
# v0.19.15

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
using Distributions, PlutoUI, LinearAlgebra, Markdown, InteractiveUtils, Documenter, HypertextLiteral, Plots

# ╔═╡ e9083ca9-9542-471d-9c4d-b8382418cde8
using D3Trees, Blink, Latexify

# ╔═╡ 7f488943-6cd3-431d-8d8b-511365b4b90b
md"# WS225 TPW1: Short Recap of your course on probability

For more information, you are kindly invited to have a look at your course on Statistics and Probability. The introduction chapters of the \"Weaponeering\" (by Morris Driels) reference book also provide some additional information.\

In this notebook, each section contains an example of an application/exercise using the covered subject. Additional exercises for those not yet at ease with the distribution to do some additional exercises. The concepts inside these exercises (Probability calculations) will further be considered known and no longer elaborated on.

💡 Let's first cover the way you should use this notebook:
- The notebook offers some interactivity, on the right side of the page you will find the table of contents, you can click the subjects to move between topics quickcly
- There are some sliders inside the notebook to help you get visual aid on some principles
- There are answer boxes in some of the sections. You can perform the exercises with pen, paper and your calculator and enter them in those boxes. If your answer is correct the red boxes underneath will turn green. You should enter values with a precision of a thousandth. (0.001) 
- Blue boxes contain hints, they are blurred by default, if you click them they reveal their information
- The notebook allows adding your own code, but the information is not stored after you quit your session, so if you want to do more permanent actions, you can download the code using the export button on top of the page (the circle and triangle icon)
- To obtain a PDF or HTML version (stripping the interactive layer), you can also use the export button.
"

# ╔═╡ e9bfc4df-4b0e-4196-9acf-4e13bf44348e
TableOfContents()

# ╔═╡ e2bf1c53-7952-4ae7-8b76-f0d5e2c47e16
md"## The uniform distribution
We will start with the uniform distribution. An easy one to start with where the probability function is \"spread\" over a certain region (a line section) The distribution outside the region (delimited with a and b) has a value of zero, within the region the value is given by: 
"

# ╔═╡ 784665d1-48b1-4ce9-8052-aa1bb72cd1a6
md"""
$$f(x) = \frac{1}{b-a}$$
"""

# ╔═╡ b3088ae8-db0b-4488-bee1-7ba76470cdd6
@bind a PlutoUI.Slider(-3:0.5:3, default=-1) 

# ╔═╡ 66ace31f-2353-407e-8774-bfc83e907771
md"""
a set to : $a""" 


# ╔═╡ 72b3ceba-7d58-484c-b680-aa13a7e72b75
@bind b PlutoUI.Slider(-3:0.5:3, default=1) 

# ╔═╡ 8238f948-3a51-4236-9b81-4237bff28900
md"""
b set to : $b""" 

# ╔═╡ a21c8daa-1640-4b44-be00-015e442616f9
if a > b 
	println("a can't be bigger than b!")
else
	𝒰ₓ = -3.5:0.01:3.5
	𝒰₁ = zeros(Float32, length(𝒰ₓ))
	for i ∈ 1:length(𝒰ₓ)
		(a .<= 𝒰ₓ[i] .<= b) ? 𝒰₁[i]=1/(b-a) : 𝒰₁[i] = 0. 
	end
	𝒰₂ = cumsum(𝒰₁.* 0.01)
	pu1 = scatter(collect(𝒰ₓ), 𝒰₁, title = "UD (PDF)", xlabel = "[m]", ylabel = "probability", xlims = (-3.5, 3.5), ylims = (-0.01, max(1/(b-a)+0.01, 1.001)))
	pu2 = scatter(collect(𝒰ₓ), 𝒰₂, title = "UD (CDF)", xlabel = "[m]", ylabel = "probability", xlims = (-3.5, 3.5), ylims = (-0.01, 1.01))
	plot(pu1, pu2, layout = (1, 2), legend = false)
end

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
❗ If you are rusty on working with normal distributions, do have a look at the process of standardization and on using a z-value table before doing additional exercises.\
💡 \" Univariate \" indicates we are dealing with 1 dimension! \
\"Uni\" → One \
\"variate\" → variable, the considered parameter (for weaponeering often [m])
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
	𝒫ₓ_cdf = cdf.(𝒩, x)
	𝒫ₓ_pdf = pdf.(𝒩, x)
	p1 = plot(collect(x), 𝒫ₓ_cdf, title = "CDF (μ = $μ , σ = $σ)") 
	xlabel!("[]")
	ylabel!("probability")
	#xlims = (-10, 10)
	#ylims = (-0.01, 1)
	p2 = plot(collect(x), 𝒫ₓ_pdf, title = "PDF (μ = $μ , σ = $σ)") 
	xlabel!("[]")
	xlims! = (-10, 10)
	ylims! = (-0.01, 1)
	plot(p1, p2, layout = (1, 2), legend = false)
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
	𝒫ₓ_pdf_ep = pdf.(𝒩ep, x)
	p3 = plot(x, 𝒫ₓ_pdf_ep, label="NL with ep", title = "PDF (μ = $μ and EP = $ep)",xlabel = "[]", ylabel = "probability")
	plot!(x, pdf.(Normal(μ,1),x), color="red", label="NL(0,1)")
	xlims = (-10, 10)
	ylims = (-0.01, 1) 
	p3
end

# ╔═╡ 0b891e54-91be-475c-a48d-45c988df1795
md" 
### Example EP
A gun is aimed at a bridge 50 m long, located in the direction of fire, at a distance of 7000 m. At this distance, the LEP is 22 m. What is the probability of hitting the bridge if the aiming point is the centre of the bridge?

"

# ╔═╡ 1a1fd879-8323-4f9c-9662-d55a36668d64
md"
💡 you can enter your result below, if your value is correct, the box below will turn green. \
❗ enter your value with three numbers after the comma
"

# ╔═╡ da951e92-f191-4b8d-b4a6-6eac4490162f
md"The probability is: $(@bind s TextField(default=\"0.666\"))"


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

# ╔═╡ 2f0be9de-8807-4f3b-9c57-72eae797f4a9
md"
💡 you can enter your result below, if your value is correct, the box below will turn green. \
❗ enter your value with three numbers after the comma
"

# ╔═╡ a5edd9df-1527-49a2-8a52-ebb5caad9400
md"The pobability is: $(@bind s2 TextField(default=\"0.666\"))"

# ╔═╡ 91f9ccfa-7e5b-46e6-a6d2-a6aaac322594
md"## The multivariate normal distribution
### Bivariate normal distribution

Let us consider axis 1 and 2 which are perpendicular. 
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

# ╔═╡ 3a66d152-3b7d-433a-a0ad-f36f37c0f90d
md"
For a standard distribution with mean impact point on the origin (0,0) and both standard deviations set to 1, calculating the probability the projectile will hit within a square of 2 by 4 meters centered on the origin, comes down to calculating the enclosed section (or area for the 3D figure). \
To simplify the calculations, the probavilities in the x- and y-direction can be calculated separatly and multiplied afterwards to obtain the selected volume under the 3D-plot.

"

# ╔═╡ f26f571b-b65f-465f-a87e-a6465858e18c
begin
	bivar_x2 = -3:0.2:3
	bivar_y2 = -3:0.2:3
	𝒩bivarx = Normal(0,1); 𝒩bivary = Normal(0,1)
	bivar_z2 = zeros(Float64, length(bivar_x2), length(bivar_y2))
	for i = 1:length(bivar_x2), j = 1:length(bivar_y2)
		bivar_z2[i,j] = pdf(𝒩bivarx, bivar_x2[i]) * pdf(𝒩bivary, bivar_y2[j])
	end
	p3bv = wireframe(bivar_x2,bivar_y2,bivar_z2, xlabel="x [m]", ylabel="y [m]", zlabel="probability")
	scatter!(bivar_x2.*0 .+ 1.0,bivar_y2, bivar_z2[:,21], color="red")
	scatter!(bivar_x2.*0 .- 1.0,bivar_y2, bivar_z2[:,11], color="red")
	scatter!(bivar_x2,bivar_y2 .* 0 .+ 2.0, bivar_z2[26,:], color="green")
	scatter!(bivar_x2,bivar_y2 .* 0 .+ -2.0, bivar_z2[6,:], color="green")
	p1bv = plot(bivar_x2, bivar_z2[:, convert(Int,ceil(length(bivar_y2)/2))], xlabel="x [m]", ylabel="probability")
	vline!([-1.0, 1.0])
	p4bv = plot(bivar_z2[convert(Int,ceil(length(bivar_y2)/2)),:], bivar_y2, 
	xlabel="probability", ylabel="y [m]")
	hline!([2.0, -2.0], color="green")
	p2bv = plot(legend=false,grid=false,foreground_color_subplot=:white)
	plot(p1bv, p2bv, p3bv, p4bv, layout = (2, 2), legend = false)
end

# ╔═╡ 7b5f672a-f466-476e-aa18-29d63f4fea91
md"
If we would like to obtain information on the probability an impact will occur within a certain distance form the average impact point, we can substitute x and y for the radius r, obtaining the Rayleigh distribution of which the CDF is given by:
"

# ╔═╡ 4a52796b-2cef-4742-bebc-f9a6eae1f81e
md"
$$P(r \leq R) = 1-e^{\frac{-R^2}{2 \sigma^2}}$$
"

# ╔═╡ fe9a7391-c6f5-4a42-9586-76470131fcd4
md"
❗ Keep in mind the Rayleigh distribution is an exeption where we are interested in a circular area centered on the mean impact point ❗
"

# ╔═╡ 51163392-a671-41ec-8df5-fbfce0622e7b
begin
	σᵣ = 1
	𝒩₁ = Normal(0,σᵣ)
	𝒩₂ = Normal(0,1σᵣ)
	R = 0:0.1:10
	ℛ = Rayleigh(σᵣ)
	ℛ_pdf = pdf.(ℛ, R)
	p4 = plot(collect(R), ℛ_pdf,xlabel = "[]", ylabel = "probability",
    title = "Rayleigh CDF (σ = $σᵣ)", xlims = (-0.01, 10), ylims = (-0.01, 1), label = false)
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

# ╔═╡ ef3cac5b-82ce-4044-9197-79a35b20c16e
md"
💡 you can enter your result below, if your value is correct, the box below will turn green. \
❗ enter your value with three numbers after the comma
"

# ╔═╡ b25d1667-16ed-4f63-ab66-0cab448213f5
md"The CEP at 1000 m in mils is: $(@bind s3 TextField(default=\"0.666\"))"

# ╔═╡ cd5c1d99-57f9-4400-96eb-f8059833b4c8
md"The probability of hitting a circle with a radius of 1 meter at 1000 meters is: $(@bind s4 TextField(default=\"0.666\"))"

# ╔═╡ 09e5ad14-705b-47de-bdd7-aaaa638b8ced
md"The probability of hitting a 4 by 2 meter target at 2000 meters (assuming a linearly growing EP) is: $(@bind s5 TextField(default=\"0.666\"))"

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
		xcep = LinRange(-1.1774,1.1774,1000)
	
		drawellips = sqrt.(1.1774^2 .- xcep.^2) .* e
		if e ≥ 0.5
			eqCEP = 1.1774*(σᵢ+σᵢ*e)/2
		else
			eqCEP = 0.562*σᵢ + 0.617*σᵢ*e
		end
		xecep = LinRange(-eqCEP, eqCEP, 1000)
		drawecep = sqrt.(eqCEP^2 .- xecep.^2)


	p5 = contour(xs, ys, zs, xlabel = "[m]", ylabel = "[m]",
    	title = "contourmap \n (σᵢ = $σᵢ, ratio = $ratio)", aspect_ratio=1.0, legend = false)

	p6 = plot(xecep, drawecep, color = "blue", label = "ECEP", xlabel = "[m]", ylabel = "[m]", title = "comparison CEP - ECEP \n (σᵢ = $σᵢ, ratio = $ratio)", aspect_ratio=1.0)
	plot!(xecep, -drawecep, color = "blue", label = false)
	plot!(drawellips, xcep, color = "red", label = "ellips")
	plot!(-drawellips, xcep, color = "red")
	
	plot(p5, p6, layout = (1, 2), legend = false)
	

end

# ╔═╡ 4c26a695-752f-4519-8941-8be66c424510
md"""
We define $$\sigma_s = min(\sigma_x, \sigma_y)$$ and $$\sigma_l = max(\sigma_x, \sigma_y)$$
"""

# ╔═╡ 4524a8d6-ab46-40aa-b556-e83fe7b734c9
md"""
💡 ECEP Rule:
- ratio standard deviations is no smaller than 0.5
use: $$CEP = 1.1774 \ \frac{\sigma_x+\sigma_y}{2}$$
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

# ╔═╡ 46b2e44c-20c8-4317-bd47-9c92d05c5389
@bind s6 TextField(default="0.666")

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

# ╔═╡ 3e6e8d61-4889-4564-8d61-7a8cd99cd19e
md"
❗ enter your value as a whole number
"

# ╔═╡ 8d49d627-f823-4ab7-8be9-35adaf5d5bb8
md"A deminer can defuze :$(@bind s7 TextField(default=\"666\")) mines"

# ╔═╡ 727e9ce3-9c79-47c9-9d22-501e0b18a8d0
md"The probability is: $(@bind s8 TextField(default=\"0.666\"))"

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
answer = parse(Float64, s)
LEP = 22
σₑₚ = 22/0.6745
Dist = Normal(7000,σₑₚ)
P = -cdf(Dist , 6975) + cdf(Dist , 7025) 


if isapprox(answer, P, atol = 0.0015)
	correct()
else
	keep_working()
end
end

# ╔═╡ 964aaeef-9559-4f77-aa3c-a8cc5a2b2228
begin
	probability_neutralisation = parse(Float64, s2)
	R90 = 120
	σR90 = R90/2.146
	DistR90 = Normal(0, σR90)
	𝒫R90 = (1-cdf(DistR90, 50))*2

	
if isapprox(probability_neutralisation, 𝒫R90, atol = 0.0015)
	correct()
else
	keep_working()
end
end

# ╔═╡ 3479272e-06b1-4ec1-9d3d-f6259799a480
begin
	CEP_1000m = parse(Float64, s3)
	if floor(CEP; digits = 3) ≤ CEP_1000m ≤ ceil(CEP; digits = 3)
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 88aa53f3-be74-4af3-b0f0-fb3db32482f9
begin
	probability_1m_circle = parse(Float64, s4)
	if floor(𝒫1k; digits = 3) ≤ probability_1m_circle ≤ ceil(𝒫1k; digits = 3)
		correct()
	else
		keep_working()
	end
end

# ╔═╡ bdc70a8c-b260-4764-b07c-2177277ddd89
begin
	probability_2km_tgt = parse(Float64, s5)
	if floor(𝒫2ktotal; digits = 3) ≤ probability_2km_tgt ≤ ceil(𝒫2ktotal; digits = 3)
		correct()
	else
		keep_working()
	end
end

# ╔═╡ 287fd3e8-ed6e-45a9-b806-da3e566993a6
begin
	𝒫𝒦 = parse(Float64, s6)
	if floor(𝒫K; digits = 3) ≤ 𝒫𝒦 ≤ ceil(𝒫K; digits = 3)
		correct()
	else
		hint(md"𝒫K = 𝒫A.𝒫D/A.𝒫L/D.𝒫I/L.𝒫H/I. 𝒫K/H")
	end
end

# ╔═╡ d7a5d690-5fc1-457f-bea2-4cd68c84d591
begin
	number_of_mines = parse(Int64, s7)
	α = 3
	ntot = 12000
	μP = 3/4
	tP = 4
	#SR = exp(- μP*tP)*(μP*tP)^0/factorial(0)
	#LR = 1-SR
	α_new =  -log(0.95)
	n = 120000*α_new
	𝒫₂ = exp(-α)*(α)^2/factorial(2)
	if isapprox(number_of_mines, n; atol=2)
		correct()
	else
		keep_working()
	end
end

# ╔═╡ b0eafcbf-f70d-4416-ab24-192c937c7bee
begin
	𝒫2deminers = parse(Float64, s8)
	if isapprox(𝒫2deminers, 𝒫₂; atol=0.002)
		correct()
	else
		keep_working()
	end
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
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Blink = "~0.12.5"
D3Trees = "~0.3.2"
Distributions = "~0.25.71"
Documenter = "~0.27.23"
HypertextLiteral = "~0.9.4"
Latexify = "~0.15.17"
Plots = "~1.35.5"
PlutoUI = "~0.7.40"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.3"
manifest_format = "2.0"
project_hash = "d63228652b2135db6807da6056a23699866fc338"

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

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "aaabba4ce1b7f8a9b34c015053d3b1edf60fa49c"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.4.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.D3Trees]]
deps = ["AbstractTrees", "JSON", "Random"]
git-tree-sha1 = "666c295cb25d7f888bef137ce5cb1ba254cd5c4b"
uuid = "e3df1716-f71e-5df9-9e2d-98e193103c45"
version = "0.3.2"

[[deps.DataAPI]]
git-tree-sha1 = "e08915633fcb3ea83bf9d6126292e5bc5c739922"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.13.0"

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

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

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
git-tree-sha1 = "7fe1eff48e18a91946ff753baf834ff4d5c03744"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.78"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "c36550cb29cbe373e95b3f40486b9a4148f89ffd"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.2"

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

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "802bfc139833d2ba893dd9e62ba1767c88d708ae"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.5"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.FunctionalCollections]]
deps = ["Test"]
git-tree-sha1 = "04cb9cfaa6ba5311973994fe3496ddec19b6292a"
uuid = "de31a74c-ac4f-5751-b3fd-e18cd04993ca"
version = "0.5.0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "00a9d4abadc05b9476e937a5557fcce476b9e547"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.69.5"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "fb83fbe02fe57f2c068013aa94bcdf6760d3a7a7"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+1"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

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
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

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

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

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

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

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

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

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
git-tree-sha1 = "6862738f9796b3edc1c09d0890afce4eca9e7e93"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.4"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6e9dba33f9f2c44e08a020b0caf6903be540004"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.19+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "cf494dca75a69712a72b80bc48f59dcf3dea63ec"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.16"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "b64719e8b4504983c7fca6cc9db3ebc8acc2a4d6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.1"

[[deps.Pidfile]]
deps = ["FileWatching", "Test"]
git-tree-sha1 = "2d8aaf8ee10df53d0dfb9b8ee44ae7c04ced2b03"
uuid = "fa939f87-e72e-5be4-a000-7fc836dbe307"
version = "1.3.0"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "b434dce10c0290ab22cb941a9d72c470f304c71d"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.35.8"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "efc140104e6d0ae3e7e30d56c98c4a927154d684"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.48"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "97aa253e65b784fd13e83774cadc95b38011d734"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.6.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "d12e612bba40d189cead6ff857ddb67bd2e6a387"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "e974477be88cb5e3040009f3767611bc6357846f"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.11"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

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

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

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
git-tree-sha1 = "c79322d36826aa2f4fd8ecfa96ddb47b174ac78d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

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

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.WebIO]]
deps = ["AssetRegistry", "Base64", "Distributed", "FunctionalCollections", "JSON", "Logging", "Observables", "Pkg", "Random", "Requires", "Sockets", "UUIDs", "WebSockets", "Widgets"]
git-tree-sha1 = "55ea1b43214edb1f6a228105a219c6e84f1f5533"
uuid = "0f1e0344-ec1d-5b48-a673-e5cf874b6c29"
version = "0.8.19"

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

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─7f488943-6cd3-431d-8d8b-511365b4b90b
# ╟─e9bfc4df-4b0e-4196-9acf-4e13bf44348e
# ╟─7741fd78-34d5-11ed-3d55-dd986e292da5
# ╟─e2bf1c53-7952-4ae7-8b76-f0d5e2c47e16
# ╟─784665d1-48b1-4ce9-8052-aa1bb72cd1a6
# ╟─66ace31f-2353-407e-8774-bfc83e907771
# ╟─b3088ae8-db0b-4488-bee1-7ba76470cdd6
# ╟─8238f948-3a51-4236-9b81-4237bff28900
# ╟─72b3ceba-7d58-484c-b680-aa13a7e72b75
# ╟─a21c8daa-1640-4b44-be00-015e442616f9
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
# ╟─1a1fd879-8323-4f9c-9662-d55a36668d64
# ╟─da951e92-f191-4b8d-b4a6-6eac4490162f
# ╟─d210926a-f42f-4bb5-9ed3-67896931d8d2
# ╟─65ec32d2-e08f-4da7-9b8f-a0d99ab11d50
# ╟─0c92ec48-8b7c-42a3-89d3-fd897d9e7115
# ╟─2f0be9de-8807-4f3b-9c57-72eae797f4a9
# ╟─a5edd9df-1527-49a2-8a52-ebb5caad9400
# ╟─964aaeef-9559-4f77-aa3c-a8cc5a2b2228
# ╟─91f9ccfa-7e5b-46e6-a6d2-a6aaac322594
# ╟─f179ae75-f110-4669-9a0b-5479918b1564
# ╟─3a66d152-3b7d-433a-a0ad-f36f37c0f90d
# ╟─f26f571b-b65f-465f-a87e-a6465858e18c
# ╟─7b5f672a-f466-476e-aa18-29d63f4fea91
# ╟─4a52796b-2cef-4742-bebc-f9a6eae1f81e
# ╟─fe9a7391-c6f5-4a42-9586-76470131fcd4
# ╟─51163392-a671-41ec-8df5-fbfce0622e7b
# ╟─0d70fb9b-2cce-4465-9589-27978961804c
# ╟─a2e6a3f6-1643-4810-b30b-d760e1398922
# ╟─537b3c21-f1bd-4ad6-ae60-5b1a35d05edd
# ╟─6b5afb26-8b6c-4d59-a9a5-be270854ad04
# ╟─3d253278-6739-432c-9c0d-b8053ed91dd5
# ╟─39236e74-5a9f-4002-861b-0ac5940ed5fa
# ╟─ce68175a-f964-4111-be70-d76fa21df25f
# ╟─ef3cac5b-82ce-4044-9197-79a35b20c16e
# ╟─b25d1667-16ed-4f63-ab66-0cab448213f5
# ╟─3479272e-06b1-4ec1-9d3d-f6259799a480
# ╟─cd5c1d99-57f9-4400-96eb-f8059833b4c8
# ╟─88aa53f3-be74-4af3-b0f0-fb3db32482f9
# ╟─09e5ad14-705b-47de-bdd7-aaaa638b8ced
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
# ╟─46b2e44c-20c8-4317-bd47-9c92d05c5389
# ╟─287fd3e8-ed6e-45a9-b806-da3e566993a6
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
# ╟─3e6e8d61-4889-4564-8d61-7a8cd99cd19e
# ╟─8d49d627-f823-4ab7-8be9-35adaf5d5bb8
# ╟─d7a5d690-5fc1-457f-bea2-4cd68c84d591
# ╟─727e9ce3-9c79-47c9-9d22-501e0b18a8d0
# ╟─b0eafcbf-f70d-4416-ab24-192c937c7bee
# ╟─e74f2c3d-561e-4776-9d37-d0032343a806
# ╟─46359fb5-c34d-4c42-9032-13291caf5e0b
# ╟─d79ba202-9de5-4388-b489-315505167b70
# ╟─96a47987-686a-4b74-8185-39c9f09e09f1
# ╟─ef9ba72b-503d-4704-8544-642d279640a4
# ╟─34407cae-7ca2-4dae-a836-11633ecda551
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
